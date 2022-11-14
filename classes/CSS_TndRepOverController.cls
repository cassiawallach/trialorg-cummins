/**********************************************************************
Name:CSS_TndRepOverController
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:                                                            
Component Controller that displays Overview Pages for Troubleshooting & Repair                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR            DATE                DETAIL                                
1.0         Gyan Pany         6/5/2016           INITIAL DEVELOPMENT                      
***********************************************************************/ 
public with sharing class CSS_TndRepOverController {   
    public Boolean isReadUser{get;set;}  
    public string dsIndicator{get;set;}
    //  public Boolean psnsererrflag{get;set;}//Story#183077
    public css_tnd_job maincontroller{get;set;}//story#183077
    public string dSidIndi{get;
                           set{
                               dSidIndi=value;
                               system.debug('dSidIndi in Set-->'+dSidIndi);
                               if(dSidIndi == 'N' || dSidIndi == 'G'){
                                   isReadUser = true;    
                               }
                               else{
                                   isReadUser = false; 
                               }
                               system.debug('isReadUser in set-->'+isReadUser);
                           }
                          }
    //End
    Public void Query_INSITE(){


    }
    public Id Ins_JobId {
        get;
        set {
            Ins_JobId = value;
            System.debug('Method*** 1' + Ins_JobId);
            system.debug('value--'+value);
            if ( value != null) {
                system.debug('Inside IF');
                rJobOrd =[Select Id,Account__r.Warranty_Training_Certification__c, Account__r.Warranty_Training_Status__c, Account__r.CERTIFICATION_END_DATE__c,Name,BMSStatus__c,Before_In_Service__c,Mileage_Measure__c, Cstmr_Contacts_Phone__c,Mileage__c,PSN_Not_Available__c,ESN__c,ESN_Insite__c,INSITE_UpdateTimeStamp__c,INSITE_ESN_Choice__c,DSID__c,Customer_Name__c,AccessCode__c,ESN_Locked__c,Insite_ESN2__c,
                          BMS_Last_Name__c, EngineFamilyCode__c, Customer_Code__c,Application__c,ApplicationCode__c,Automotive_App_Flag__c,SPDataWebserviceResult__c,Application_Desc__c,Unit_Number__c,Failure_Point__c,Failure_Point_Measure__c,Make__c,Model__c,Creator_Location__c,Insite_ESN2_Select__c,Unit_Type__c,
                          Equipment_ID__c,VIN__c,Account__r.Product_Certification__c,Location_Certification__c, Qsol_Engine_Family_Code__c,Repair_Location__c, Previous_Status__c, Warranty_Start_Date__c,Phone_Number__c,First_Name__c,Failure_Date__c,Account__c,Account__r.WR_Certfication_Flag__c,SP_ProductCertification__c,DSID_WorkGroup__c,Service_Model__c,Sub_Type__c,Shop_Work_Order__c,GTIS_Message_Type__c,Status__c,DisplayGtis__c from CSS_Job_Order__c where id= :value];

                system.debug('rJobOrd--'+rJobOrd);

                if (rJobOrd.INSITE_UpdateTimeStamp__c !=null && rJobOrd.INSITE_ESN_Choice__c == 'Not Selected' && rJobOrd.ESN__c!= rJobOrd.ESN_Insite__c && displayINPop!=false && rJobOrd.ESN_Locked__c == false) {
                    System.debug('entered into show popup constructor...');
                    showINPopup();
                }
                else {
                    closeINPopup();
                }
                if(rJobOrd.ESN_Insite__c!=null && rJobOrd.ESN_Locked__c == true && rJobOrd.ESN_Insite__c !=rJobOrd.Insite_ESN2__c && rJobOrd.Insite_ESN2_Select__c!=false){
                    showESNLockPopUp();
                }
                else{
                    closeESNLockPopUp();
                }
                system.debug('Anirudh'+'rJobOrd.ESN_Insite__c>>>>'+rJobOrd.ESN_Insite__c + ' ' + 'rJobOrd.ESN_Locked__c' +rJobOrd.ESN_Locked__c + ' ' + 'rJobOrd.Insite_ESN2__c' + rJobOrd.Insite_ESN2__c + ' ' + 'rJobOrd.Insite_ESN2_Select__c' +rJobOrd.Insite_ESN2_Select__c);
                if (rJobOrd.INSITE_UpdateTimeStamp__c !=null) {
                    sftdDate = rJobOrd.INSITE_UpdateTimeStamp__c.format('dd MMM yyyy - hh:mm a z');
                }

                if(rJobOrd.GTIS_Message_Type__c != null && rJobOrd.DisplayGtis__c == false){
                    mCode = Integer.valueOf(rJobOrd.GTIS_Message_Type__c);
                    showGitsPopup();                                        
                }
            }
        }
    }
    public string pageName{get;
                           set{
                               pageName = value;
                           }}
    public css_job_order__c rJobOrd {get;set;}

    public integer mCode {get;set;}
    public String sftdDate {get;set;}
    public Boolean displayINPop {get;set;}
    public Boolean esnLockPopUp{get;set;}
    public Boolean displayINncPop {get;set;}
    public Boolean displayGitsPop{get;set;}
    public Boolean isPrioritized {get;set;}
    public Boolean isfaultCodeView {get;set;} 
    public Boolean poleWarningMsg{get;set;}
    public Boolean poleVerified{get;set;}
    public boolean checkSol{get;set;}
    public Boolean bmsEnabled;
    public Boolean getchfalcheckmakemodel{get;set;}
    public Boolean getchfalcheckmakemodelbtn{get;set;}
      public Boolean blankAppMakeModel{get;set;}
    //public User u3{get;set;}
    public CSS_accountLanguage__c aLang{get;set;}

    public CSS_TndRepOverController() {
        getchfalcheckmakemodel = false;
        getchfalcheckmakemodelbtn = false;

        String QId = ApexPages.CurrentPage().getParameters().get('DSID');
        system.debug('Gyan**-'+QId);
        isfaultCodeView   = true;
        checkSol=false;
        maincontroller= new css_tnd_job ();
        //u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
        if(!Test.isRunningTest())
            aLang = css_utility.getLanguage((String)Cache.Session.get('local.CSSPartition.UserLanguageLocaleKey'));

        if (QId == 'NC') {
            showINncPopup();
        }
        String JobId = ApexPages.CurrentPage().getParameters().get('id');
        Ins_JobId = (Id)JobId;
        allfcs = getAllFCWrapper();
        //flag to show error message and enable /disable getfaultcode button and error message


        if((rJobOrd.Application_Desc__c!='Select One' && rJobOrd.Application_Desc__c!=null && rJobOrd.Application_Desc__c!='') && 
           (rJobOrd.Make__c!='Select One' && rJobOrd.Make__c!='----Select One ----' && rJobOrd.Make__c!='----None----' && rJobOrd.Make__c!=null && rJobOrd.Make__c!='') && (rJobOrd.Model__c!='Select One' && rJobOrd.Model__c!='----Select One ----' && rJobOrd.Model__c!='----None----' && rJobOrd.Model__c!=null && rJobOrd.Model__c!='') && (rJobOrd.DSID__c!=null && rJobOrd.DSID__c!='')){
            getchfalcheckmakemodel=false;
            getchfalcheckmakemodelbtn= false;
            system.debug('getchfalcheckmakemodel'+getchfalcheckmakemodel);

        }
        else if ((rJobOrd.Application_Desc__c!='Select One' && rJobOrd.Application_Desc__c!=null && rJobOrd.Application_Desc__c!='') && 
                 (rJobOrd.Make__c!='Select One' && rJobOrd.Make__c!='----Select One ----' && rJobOrd.Make__c!='----None----' && rJobOrd.Make__c!=null && rJobOrd.Make__c!='') && (rJobOrd.Model__c!='Select One' && rJobOrd.Model__c!='----Select One ----' && rJobOrd.Model__c!='----None----' && rJobOrd.Model__c!=null && rJobOrd.Model__c!='') && (rJobOrd.DSID__c == null || rJobOrd.DSID__c == '')){
            getchfalcheckmakemodel=true;
            getchfalcheckmakemodelbtn= false;
            system.debug('getchfalcheckmakemodel'+getchfalcheckmakemodel);

        }
        else{
            getchfalcheckmakemodel= true;
            getchfalcheckmakemodelbtn= true;

        }



        if((rJobOrd.Application_Desc__c!='Select One' && rJobOrd.Application_Desc__c!=null && rJobOrd.Application_Desc__c!='') && 
           (rJobOrd.Make__c!='Select One' && rJobOrd.Make__c!='----Select One ----' && rJobOrd.Make__c!='----None----' && rJobOrd.Make__c!=null && rJobOrd.Make__c!='') && (rJobOrd.Model__c!='Select One' && rJobOrd.Model__c!='----Select One ----' && rJobOrd.Model__c!='----None----' && rJobOrd.Model__c!=null && rJobOrd.Model__c!='') && (rJobOrd.ESN_Insite__c == null || rJobOrd.ESN_Insite__c =='')){
            getchfalcheckmakemodel= false;
        }
        system.debug('getchfalcheckmakemodel'+getchfalcheckmakemodel);

    }
    css_job_order__c woInESN= new css_job_order__c();
    public PageReference pgChInsiteESN()
    {
        system.debug('Entered pgChInsite ESN Method*** - Anirudh');
        PageReference pageRef;
        try{
            makespdataservicecall(rJobOrd);
            startRequest(rJobOrd.ESN_Insite__c,'UseCSSEsn');
            if(HHSPACCSFlg==true || HHSPSMNFlg==false){
                System.debug('Inside system esn-3');
                // bmsEnabled = css_utility.getBMSEnabled(userinfo.getUserId());

                System.debug('entered before overwrite ESN');
                if((woInESN.Application_Desc__c != null || (rJobOrd.Application_Desc__c!='Select One' && rJobOrd.Application_Desc__c!=null && rJobOrd.Application_Desc__c!='')) && (woInESN.Make__c != null || (rJobOrd.Make__c!='Select One' && rJobOrd.Make__c!=null && rJobOrd.Make__c!='' && rJobOrd.Make__c!='----Select One ----' && rJobOrd.Make__c!='----None----')) && (woInESN.Model__c!=null || (rJobOrd.Model__c!='Select One' && rJobOrd.Model__c!=null && rJobOrd.Model__c!='' && rJobOrd.Model__c!='----Select One ----' && rJobOrd.Model__c!='----None----'))){
                    blankAppMakeModel=false;
                    woInESN.INSITE_ESN_Choice__c='Overwrite ESN';
                    System.debug('entered after Overwrite ESN');
                    woInESN.ESN__c=rJobOrd.ESN_Insite__c;
                    /**** Moved the Code here to Generic Method*** at the last*******/
                    createDSIDAndBMSLookup();
                    closeINPopup();
                    String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
                    pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
                    pageRef.setRedirect(true);

                    //Updating the selected Unit Number from BMS
                    if(rJobOrd.Unit_Number__c!=null && rJobOrd.BMSStatus__c!=null){
                        system.debug('Entered into Unit Number Update Anirudh');
                        //woInESN.Unit_Number__c = rJobOrd.Unit_Number__c;
                        //woInESN.BMSStatus__c = rJobOrd.BMSStatus__c;
                        system.debug('UnitNumber>>>>>>'+rJobOrd.Unit_Number__c);
                    }
                    addHHPEsnToAuditTrail();
                    woInESN.Id = rJobOrd.Id;
                    woInESN.SPDataWebserviceResult__c=spdatastatus;
                    update woInESN;

                }else{
                    blankAppMakeModel=true;
                    return null;

                }        
            }else{
                system.debug('Anirudh'+'displayHHPPopup2>>>>>'+displayHHPPopup2);
                addHHPEsnToAuditTrail();
                return null;
            }
        }catch(exception e){
            System.debug('in catch block of pgChInsiteESN controller lineNo:'+e.getLineNumber()+' Exception message:'+e.getMessage());

        }
        // System.debug('UnitOutboundDetails>>>>>>>>>>>>>>>>>>>>>:'+UnitOutboundDetails);
        // System.debug('UnitOutboundDetails.DataArea>>>>>>>>>>>>>>>>>>>>>:'+UnitOutboundDetails.DataArea);
        //The below condition is to display UnitLookUp popup immediately after updating Insite ESN
        if(bmsEnabled == true && rJobOrd.ESN__c!=null && rJobOrd.ESN_Insite__c!=null && UnitOutboundDetails.DataArea!=null && UnitOutboundDetails.DataArea.size()>0 && !UnitOutboundDetails.DataArea.isempty()){
            System.debug('entered UnitOutboundDetails.DataArea>>>>>>>>>>>>>>>>>>>>>:'+UnitOutboundDetails.DataArea);
            return null;
        }else{     
            //System.debug('in else UnitOutboundDetails.DataArea>>>>>>>>>>>>>>>>>>>>>:'+UnitOutboundDetails.DataArea);
            return pageRef;
        }

    }

    public PageReference pgChJoESN()
    {
        displayHHPPopup2 = false;
        PageReference pageRef;
        try{
            System.debug('Inside system esn');
            css_job_order__c woTyESN= new css_job_order__c();
            //Create DSID
            makespdataservicecall(rJobOrd);
             //ROD Bentely 188965 condition to check application, make and model null 
             if( rJobOrd.DSID__c == null && rJobOrd.ESN__c != null && rJobOrd.Customer_Name__c != null && (woInESN.Application_Desc__c != null || (rJobOrd.Application_Desc__c!='Select One' && rJobOrd.Application_Desc__c!=null && rJobOrd.Application_Desc__c!='')) && (woInESN.Make__c != null || (rJobOrd.Make__c!='Select One' && rJobOrd.Make__c!=null && rJobOrd.Make__c!='' && rJobOrd.Make__c!='----Select One ----' && rJobOrd.Make__c!='----None----')) && (woInESN.Model__c!=null || (rJobOrd.Model__c!='Select One' && rJobOrd.Model__c!=null && rJobOrd.Model__c!='' && rJobOrd.Model__c!='----Select One ----' && rJobOrd.Model__c!='----None----'))){
                blankAppMakeModel=false;
                DSID = CSS_EDSAuthentication.getDSID(rJobOrd.ESN__c,rJobOrd.Name,rJobOrd.Application_Desc__c,rJobOrd.Unit_Number__c,rJobOrd.Mileage__c,
                                                     rJobOrd.Mileage_Measure__c,rJobOrd.Make__c,rJobOrd.Model__c,rJobOrd.Equipment_ID__c,rJobOrd.Customer_Name__c,
                                                     rJobOrd.Service_Model__c,rJobOrd.Shop_Work_Order__c,rJobOrd.AccessCode__c); 
                woTyESN.DSID__c = DSID;
                woTyESN.DSID_Creation_Timestamp__c = System.now();
                woTyESN.DSID_Status__c = 'Open';
                //woTyESN.DSID_WorkGroup__c = u3.Work_Group_Name__c;
                woTyESN.DSID_WorkGroup__c = (String)Cache.Session.get('local.CSSPartition.UserEDSWorkGroupName');
                //woTyESN.DSID_Owner__c = u3.FederationIdentifier;
                woTyESN.DSID_Owner__c = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
                woTyESN.ESN_Locked__c = True;
            }else{
              blankAppMakeModel=true;
            }
          
            //End DSID   
            System.debug('Inside system esn-1');    
            woTyESN.INSITE_ESN_Choice__c='Keep Typed ESN';
            //Story Number - 71586
            if(woTyESN.DSID__c!=null){
                System.debug('Inside system esn-2');
                solutionNumber(woTyESN.DSID__c);
            }
            System.debug('Method*** 4');
            woTyESN.id=rJobOrd.id;
            woInESN.SPDataWebserviceResult__c=spdatastatus;
            update woTyESN;
            closeINPopup();
            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
            pageRef.setRedirect(true);
            // return pageRef;
        }
        catch(exception e){}
        return pageRef;
    } 
    public PageReference pgCancelClose()
    {
        closeINPopup();
        closeINncPopup();
        System.debug('Method*** 5');
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        PageReference pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void solutionNumber(string dsid){
        try{
            AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
            integer maxSeq = integer.valueOf(sequence [0].get('maxSeq'));
            List<CSS_Fault_Code__c> fc= new List<CSS_Fault_Code__c>();
            fc = [select id,name,DSID__c,Job_Order__c,Number_of_Solutions__c from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId and Sequence__c=:maxSeq];
            Map<ID,ID>  jobOrder = new Map<ID,ID>();
            Map<ID,String> faultCode = new Map<ID,String>();
            for(integer i=0;i<fc.size();i++){
                if(fc[i].Number_of_Solutions__c==null){
                    jobOrder.put(fc[i].id,fc[i].Job_Order__c);
                    faultCode.put(fc[i].id,fc[i].name); 
                    //dsid = fc[0].dsid__c;
                }
            }
            System.debug('Method*** 6');
            string language = 'en';
            System.debug('The dsid is'+dsid);
            if(dsid!=null){
                CSS_EDSAuthentication.getFaultCodeSearch(jobOrder, faultCode,dsid,aLang.CSS_EDSLanguage__c, rJobOrd); 
            }
        }
        catch(exception e){

        }
    }
    public css_job_order__c JobData;
    public string spdatastatus='';
    public void makespdataservicecall(css_job_order__c spdata){
        try{
            spdatastatus= CG_BL_Intake.fetchSPData(spdata,spdata.creator_location__c, null, spdata.Failure_Date__c, spdata.id).SPDataWebserviceResult__c;

        }catch(exception ex){
            System.debug(ex) ;
        }

    }

    public PageReference pgFCRefresh()
    {
        PageReference pageRef;   
        try{
            //bmsEnabled = css_utility.getBMSEnabled(userinfo.getUserId());
            bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
            JobData = [Select Id,creator_location__c,Failure_Date__c,SPDataWebserviceResult__c,Name,Insite_ESN2__c,Insite_ESN2_Select__c,ESN_Locked__c,ESN_Insite__c,DSID__c,ESN__c,Customer_Name__c,Application__c,Unit_Number__c,Mileage__c,Mileage_Measure__c,Make__c,Model__c,Equipment_ID__c,Service_Model__c,Shop_Work_Order__c,AccessCode__c,Application_Desc__c from CSS_Job_Order__c where id= :rJobOrd.Id];
            /***** To call Start Request and to check if the user is certified to work on HHP Engines ******/
            makespdataservicecall(JobData);
            woInESN.Id = rJobOrd.Id;
            woInESN.SPDataWebserviceResult__c=spdatastatus;

          system.debug('rJobOrd.PSN_Not_Available__c'+rJobOrd.PSN_Not_Available__c);
              system.debug('rJobOrd.PSN_Not_Available__c'+rJobOrd.PSN_Not_Available__c);
              system.debug('rJobOrd.ESN__c'+rJobOrd.ESN__c);
              system.debug('JobData.ESN_Insite__c'+JobData.ESN_Insite__c);
              system.debug('rJobOrd.Application__c'+rJobOrd.Application__c);
              system.debug('rJobOrd.ApplicationCode__c'+rJobOrd.ApplicationCode__c);
             system.debug('JobData.ApplicationCode__c'+JobData.ApplicationCode__c);
            
           // 188965 
            if(rJobOrd.PSN_Not_Available__c == true && (string.isEmpty(rJobOrd.ESN__c) || ( !string.isempty(rJobOrd.ESN__c) && !string.isEmpty(JobData.ESN_Insite__c) && rJobOrd.ESN__c != JobData.ESN_Insite__c) )){
                system.debug('ESN------>'+rJobOrd.ESN__c);
                startRequest(JobData.ESN__c,'CloseJob');

                if(HHSPACCSFlg==true || HHSPSMNFlg==false){
                    createDSIDAndBMSLookupInPgFcRefresh();
                    addHHPEsnToAuditTrail();
                }else{
                    addHHPEsnToAuditTrail();
                    System.debug('===RETURNING NULL 260');
                    /*story#183077*/
                    CSS_Job_Order__c jo = new CSS_Job_Order__c();
                    jo.Id = rJobOrd.Id;
                    //jo.SPDataWebserviceResult__c=rJobOrd.SPDataWebserviceResult__c;
                    jo.SPDataWebserviceResult__c=spdatastatus;

                    if(maincontroller.PSNFlagtnd!=null && rJobOrd.PSN_Not_Available__c == true)
                        jo.Get_Engine_data_flag__c=maincontroller.PSNFlagtnd;
                    update jo;
                    /*end*/
                    return null;
                }

            }else{
                createDSIDAndBMSLookupInPgFcRefresh1();
            }

            System.debug('Method*** 7');
            if(JobData.Insite_ESN2_Select__c == true && JobData.Insite_ESN2__c!= rJobOrd.Insite_ESN2__c)
                blnFcCodeAvl = true;
            /* END - Defect Fix - 50087 - Two popup's were being shown */
            /* BEGIN - Defect Fix - 50304 - Dont Show Popup for same ESN */
            if (blnFcCodeAvl) {
                if (rJobOrd.ESN__c!= rJobOrd.ESN_Insite__c && rJobOrd.Insite_ESN2__c == null){
                    /* END - Defect Fix - 50304 - Dont Show Popup for same ESN */
                    showINPopup();
                }else if(rJobOrd.Insite_ESN2__c!=null){
                    if(rJobOrd.Insite_ESN2__c!=rJobOrd.ESN__c && rJobOrd.ESN_Locked__c == TRUE){
                        showESNLockPopUp();
                    }
                }
                system.debug('Gyan*Method****displayINncPop=' + displayINncPop);
                String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
                pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
                System.debug('===SETTING REDIRECT TRUE 283====');
                pageRef.setRedirect(true);
                //return pageRef;
            } 
            else {
                showINncPopup();
                String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
                pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=NC'); 
                pageRef.setRedirect(true);
                System.debug('===SETTING REDIRECT TRUE 292====');
                //return pageRef;
            }

            //woInESN.SPDataWebserviceResult__c=rJobOrd.SPDataWebserviceResult__c;
            /*story#183077*/
            if(maincontroller.PSNFlagtnd!=null && rJobOrd.PSN_Not_Available__c == true)
                woInESN.Get_Engine_data_flag__c=maincontroller.PSNFlagtnd;
            /*end*/
             woInESN.Id = rJobOrd.Id;
            update woInESN;
        }
        catch(exception e){
            /*story#183077*/
            if(rJobOrd.Id!=null){
                CSS_Job_Order__c jo = new CSS_Job_Order__c();
                jo.Id = rJobOrd.Id;
                if(maincontroller.PSNFlagtnd!=null && rJobOrd.PSN_Not_Available__c == true)
                    jo.Get_Engine_data_flag__c=maincontroller.PSNFlagtnd;
                jo.SPDataWebserviceResult__c=spdatastatus;
                update jo;
            }
            /*end*/
            system.debug('Inside pgFCRefresh'+e.getLineNumber() +' '+ e.getMessage());
        }
        if(rJobOrd.PSN_Not_Available__c==true && bmsEnabled==true && UnitOutboundDetails.DataArea!=null){
            system.debug('Entered into unit lookup pop up true - Anirudh');

            return null;
        }else{ 

            return pageRef;
        }
    }
    public void showESNLockPopUp(){
        esnLockPopUp = true;
    }
    public void closeESNLockPopUp(){
        CSS_Job_Order__c job = new CSS_Job_Order__c();
        system.debug('Anirudh Insite_ESN2_Select__c in close popup method'+rJobOrd.Insite_ESN2_Select__c);
        if(rJobOrd.Insite_ESN2_Select__c){
            job.id = rJobOrd.id;
            job.Insite_ESN2_Select__c = false;
            job.Insite_ESN2__c = '';
            update job;
        }
        esnLockPopUp = false;
    }

    public void showINPopup() {
        displayINPop = true;
    }

    public void showINncPopup() {
        displayINncPop = true;
    }  
    public void closeINPopup() {
        displayINPop = false;


    }    
    public void closeINncPopup() {
        displayINncPop = false;
    }

    public void showGitsPopup()
    {
        displayGitsPop =  true;
    }

    public void closeGitsPopup() {

        displayGitsPop = false;
        css_job_order__c woInGtis= new css_job_order__c();
        woInGtis.id=rJobOrd.id;
        woInGtis.DisplayGtis__c=true;
        update woInGtis;

        system.debug('Calling Close GTIS1'+displayGitsPop);
        if (mCode ==1 || mCode ==2){
            redirectGtis(mCode);
        }
    }

    public PageReference redirectGtis(integer cd )
    {
        PageReference pageRef;
        if (cd == 1){
            system.debug('calling redirectGtis cd=1');
            pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        }
        else if(cd ==2){
            pageRef = new pageReference('/apex/CSS_JobTnD?id='+rJobOrd.id);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }


    public class faultcodeswrapper{
        public List<CSS_Fault_Code__c> faultCodes{set;get;}
        public List<CSS_Fault_Code__c> unPrioritizedFaultCodes{set;get;}
        // Defect- 106409
        public String UpdatedTimeStamp{set;get;}  
        //end        
        public String module{set;get;}
        public String primOrSecond {set;get;}
        public Boolean displyFaultCode{set;get;}
        public faultcodeswrapper(List<CSS_Fault_Code__c> fcs,List<CSS_Fault_Code__c> unfcs,String mod,String prim,String upd,boolean disfcs){
            this.faultCodes = fcs;
            this.unPrioritizedFaultCodes = unfcs;
            this.module = mod;            
            this.primOrSecond = prim;
            this.UpdatedTimeStamp = upd;
            this.displyFaultCode = disfcs;
            System.debug('Method*** 8');
        }   
    }  
    public class AllOtherFCWrapper implements Comparable{
        public List<faultcodeswrapper> Wrwrap{set;get;}
        public Datetime UpdatedTimeStamp{set;get;}
        // Defect- 106409
        public String UpdatedTimeStampvalue{set;get;}
        public AllOtherFCWrapper(List<faultcodeswrapper> wrList,Datetime updDtime, String updt){
            this.Wrwrap = wrList;
            this.UpdatedTimeStamp = updDtime;
            this.UpdatedTimeStampvalue=updt;
            System.debug('Method*** 9');
        }
        public Integer compareTo(Object compareTo) 
        {   AllOtherFCWrapper wr = (AllOtherFCWrapper)compareTo;            
         Integer returnValue = 0;
         if (UpdatedTimeStamp > wr.UpdatedTimeStamp) {
             returnValue = -1;
         } else if (UpdatedTimeStamp < wr.UpdatedTimeStamp) {
             returnValue = 1;
         }            
         return returnValue;                 
        }        
    }
    public List<AllOtherFCWrapper> getAllOtherFCWrapper(){
        List<AllOtherFCWrapper> res = new List<AllOtherFCWrapper>();
        //  if(allfcs == null)
        //     allfcs = getAllFCWrapper();
        if(allfcs != null){
            system.debug('allfcs: '+allfcs);
            List<Integer> seqs= new List<Integer>();
            system.debug('allfcs.keySet() '+allfcs.keySet());
            seqs.addAll(allfcs.keySet());
            max = getMax(seqs);
            system.debug('allfcs.keySet() Max' + max);
            allfcs.remove(max); 
            system.debug(' after remove(max)' + allfcs);
            for(Integer key:allfcs.keySet()){
                AllOtherFCWrapper newfcwrap = null;
                List<faultcodeswrapper> wrList = allfcs.get(key);
                for(faultcodeswrapper wrp:wrList){
                    if(wrp.faultCodes.size()>0){
                        newfcwrap = new AllOtherFCWrapper(wrList,wrp.faultCodes[0].createdDate,String.valueOf(wrp.faultCodes[0].createdDate.format('dd MMM yyyy - hh:mm a z')));
                        break;
                    }
                    else if(wrp.unPrioritizedFaultCodes.size()>0){
                        newfcwrap = new AllOtherFCWrapper(wrList,wrp.unPrioritizedFaultCodes[0].createdDate,String.valueOf(wrp.unPrioritizedFaultCodes[0].createdDate.format('dd MMM yyyy - hh:mm a z')));
                        break;
                    }
                }
                if(newfcwrap != null)
                    res.add(newfcwrap);
                system.debug('*** res ** '+ res);
            }
            res.sort();
        }
        System.debug('Method*** 10' + res);
        return res;        
    }
    public Integer max {set;get;}
    public Map<Integer,List<faultcodeswrapper>> allfcs{set;get;}
    public List<faultcodeswrapper> FCWrapper;

    public List<faultcodeswrapper> getFCWrapper(){   
        FCWrapper = new List<faultcodeswrapper>();
        allfcs = getAllFCWrapper();
        if(allfcs != null){
            system.debug('allfcs: '+allfcs);
            List<Integer> seqs= new List<Integer>();
            seqs.addAll(allfcs.keySet());
            system.debug('before max' + seqs);
            max = getMax(seqs);
            system.debug('After max');
            FCWrapper = allfcs.get(max);
        }
        System.debug('Method*** 11');
        return FCWrapper;
    }    
    public Integer getMax(List<Integer> lst){
        Integer maxNum = lst[0];
        Integer minNum = lst[0];
        for(Integer i=1; i< lst.size(); i++){
            if(lst[i]> maxNum)
                maxNum = lst[i];
            else if (lst[i] < minNum)
                minNum = lst[i];
        }
        System.debug('Method*** 12');
        return maxNum;
    } 

    //public List<faultcodeswrapper> FCWrapper;
    public Boolean noFaultCodes{get;set;}
    public map<Integer,List<faultcodeswrapper>> getAllFCWrapper()
    {
        List<CSS_Fault_Code__c> allFaultCodes = [Select Name,Primary_Fault_Code__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,
                                                 Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c,Status__c,Count__c,(select name,symptom__c,FaultCode__c ,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c, Rank__c  from CSS_Solutions__r order by LastModifiedDate asc)  
                                                 from CSS_Fault_Code__c 
                                                 where Job_Order__c=:Ins_JobId order by Order__c,sequence__c ];

        //BEGIN - For Solutions, Components & SRT
        lstFC = allFaultCodes;
        lstSolsForFC = new List<CSS_Solutions__c>([select Name,Nested_Rank__c,CSS_Nested_Solutions__c, CSS_Nested_Solutions__r.Name, CSS_Nested_Solutions__r.Case_Name__c, FaultCode__r.Id,FaultCode__r.isPole__c,Out_Of_order__c, Id,Case_Name__c,
                                                   Solution_Title__c,Diagnostic_Response__c,rank__c,Repair_Response__c                                                              
                                                   from      CSS_Solutions__c 
                                                   where      Service_Job__c=:Ins_JobId order by LastModifiedDate asc]);

        lstCompForSol = new List<CSS_Solution_Component__c>([select Solutions__c,Component_Id__c,name,Quantity__c,Action__c,  (Select Id,name,Part_Name__c,FailurepartId__c,Service_partnumber__c,Service_Job__c from CSS_Parts_Options__r where selected_part__c=true), 
                                                             Service_Job__c,Solutions__r.Repair_Response__c 
                                                             from CSS_Solution_Component__c where Service_Job__c=:Ins_JobId and Selected_Component__c=true]);

        lstSRTForFC = new List<CSS_SRT__c>([select Solution_Number__r.FaultCode__r.Id, Solution_Number__r.Repair_Response__c, Component_Id__r.Selected_Component__c, Solution_Number__c, Id, SRT_ID__c,Name,
                                            SRT_Time__c,Diagnosis_Time__c, Repair_Time__c , Type__c,SRT_Quantity__c,Job_Engine_Access_Code__c,
                                            isPerformed__c from CSS_SRT__c where Job_Order__c=:Ins_JobId]);
        //END - For Solutions, Components & SRT

        if(allFaultCodes.size()>0){
            map<Integer,List<CSS_Fault_Code__c>> faultCodebySeq = getfaultCodebySeq(allFaultCodes);
            allfcs = new map<Integer,List<faultcodeswrapper>>();
            for(Integer seq: faultCodebySeq.keySet()){
                system.debug('Sequence:'+seq);
                List<CSS_Fault_Code__c> faultcodes= faultCodebySeq.get(seq);
                if(!faultcodes.isEmpty() && faultcodes.size()>0){
                    List<CSS_Fault_Code__c> priorFcs = new List<CSS_Fault_Code__c>();
                    List<CSS_Fault_Code__c> unPriorFcs = new List<CSS_Fault_Code__c>();
                    Set<Integer> modSet = new Set<Integer>();
                    for(CSS_Fault_Code__c fc:faultcodes){
                        if(fc.Mod__c != null && fc.Mod__c != ''){
                            modSet.add(Integer.valueOf(fc.Mod__c));
                            if((fc.FaultCode__c != null && !fc.FaultCode__c.containsIgnoreCase('a0')) && (fc.Fault_Code_Type__c=='APD-P' || fc.Fault_Code_Type__c=='APD-R' || fc.Fault_Code_Type__c=='BPD'))
                                priorFcs.add(fc);
                            else if((fc.FaultCode__c != null && !fc.FaultCode__c.containsIgnoreCase('a0')) && (fc.Fault_Code_Type__c!='APD-P' && fc.Fault_Code_Type__c!='APD-R' && fc.Fault_Code_Type__c!='BPD'))
                                unPriorFcs.add(fc);
                        }
                    }
                    map<String,List<CSS_Fault_Code__c>> fcmap = getMapforfaultcodes(priorFcs);
                    map<String,List<CSS_Fault_Code__c>> unprfcmap = getMapforfaultcodes(unPriorFcs); 
                    List<Integer> modSet1 = new List<Integer>();
                    modSet1.addAll(modSet);
                    modSet1.sort();
                    FCWrapper = new List<faultcodeswrapper>();
                    system.debug('modSet1>>>>>'+modSet1);
                    for(Integer mod:modSet1){                        
                        String m= String.valueOf(mod);
                        String prim = '';                          
                        List<CSS_Fault_Code__c> fcs = new List<CSS_Fault_Code__c>();
                        List<CSS_Fault_Code__c> unfcs = new List<CSS_Fault_Code__c>();
                        // Datetime UpdatedTimeStamp;
                        String UpdatedTimeStamp;
                        if(fcmap.containsKey(m)){
                            fcs = fcmap.get(m);  
                            //Defect 106409
                            UpdatedTimeStamp = String.ValueOf(fcs[0].CreatedDate.format('dd MMM yyyy - hh:mm a z'));
                            //UpdatedTimeStamp = (fcs[0].CreatedDate).format('dd MMM yyyy - hh:mm a z');

                            sftdDate = String.ValueOf(fcs[0].CreatedDate.format('dd MMM yyyy - hh:mm a z'));
                        }
                        system.debug('fcmap>>>>>>>'+fcmap+ ' ' + 'unprfcmap>>>>>' + unprfcmap);
                        if(unprfcmap.containsKey(m)){
                            unfcs = unprfcmap.get(m);
                            //Defect 106409
                            UpdatedTimeStamp = String.ValueOf(unfcs[0].CreatedDate.format('dd MMM yyyy - hh:mm a z'));

                            // UpdatedTimeStamp = (unfcs[0].CreatedDate).format('dd MMM yyyy - hh:mm a z');
                            sftdDate = String.ValueOf(unfcs[0].CreatedDate.format('dd MMM yyyy - hh:mm a z'));
                        }
                        if(m == '' || m == null)
                            prim = '';
                        else if(m == '00' || m == '0')
                            prim = 'Primary';
                        else
                            prim = 'Secondary';  
                        boolean dispfcs = true;
                        for(CSS_Fault_Code__c faultcd: fcs){
                            system.debug('faultcd.Name::::: '+faultcd.FaultCode__c);
                            if(('Blank').equals(faultcd.FaultCode__c)){
                                dispfcs = false;
                                break;
                            }
                        }
                        for(CSS_Fault_Code__c faultcd: unfcs){
                            system.debug('faultcd.Name::::: '+faultcd.FaultCode__c);
                            if(('Blank').equals(faultcd.FaultCode__c)){
                                dispfcs = false;
                                noFaultCodes = true;
                                break;
                            }
                        }                        
                        FCWrapper.add(new faultcodeswrapper(fcs,unfcs,m,prim,UpdatedTimeStamp,dispfcs));
                    }                       
                    allfcs.put(seq,FCWrapper);
                }                
            }
        }
        System.debug('Method*** 13');
        return allfcs;
    }        
    public map<Integer,List<CSS_Fault_Code__c>> getfaultCodebySeq(List<CSS_Fault_Code__c> faultCodes){
        map<Integer,List<CSS_Fault_Code__c>> mapModfc = new map<Integer,List<CSS_Fault_Code__c>>();          
        for(CSS_Fault_Code__c fc:faultCodes){
            Integer seq = Integer.valueOf(fc.Sequence__c); 
            if(mapModfc.containsKey(seq)){
                mapModfc.get(seq).add(fc);
            }else{
                List<CSS_Fault_Code__c> fclist = new List<CSS_Fault_Code__c>{fc};
                mapModfc.put(seq,fclist);
            }
        }    
        System.debug('Method*** 14');
        return mapModfc;
    }    
    string DSID;
    public void createDSID(){
         if( rJobOrd.DSID__c == null && rJobOrd.ESN__c != null && rJobOrd.Customer_Name__c != null && rJobOrd.Customer_Name__c != null && (woInESN.Application_Desc__c != null || (rJobOrd.Application_Desc__c!='Select One' && rJobOrd.Application_Desc__c!=null && rJobOrd.Application_Desc__c!='')) && (woInESN.Make__c != null || (rJobOrd.Make__c!='Select One' && rJobOrd.Make__c!=null && rJobOrd.Make__c!='' && rJobOrd.Make__c!='----Select One ----' && rJobOrd.Make__c!='----None----')) && (woInESN.Model__c!=null || (rJobOrd.Model__c!='Select One' && rJobOrd.Model__c!=null && rJobOrd.Model__c!='' && rJobOrd.Model__c!='----Select One ----' && rJobOrd.Model__c!='----None----'))){
             blankAppMakeModel=false;
            DSID = CSS_EDSAuthentication.getDSID(rJobOrd.ESN__c,rJobOrd.Name,rJobOrd.Application_Desc__c,rJobOrd.Unit_Number__c,rJobOrd.Mileage__c,
                                                 rJobOrd.Mileage_Measure__c,rJobOrd.Make__c,rJobOrd.Model__c,rJobOrd.Equipment_ID__c,rJobOrd.Customer_Name__c,
                                                 rJobOrd.Service_Model__c,rJobOrd.Shop_Work_Order__c,rJobOrd.AccessCode__c);  
            rJobOrd.DSID__c = DSID;
            rJobOrd.DSID_Creation_Timestamp__c = System.now();
            rJobOrd.DSID_Status__c = 'Open';
            //rJobOrd.DSID_WorkGroup__c = workGroup;
            update rJobOrd;
        }
        else{
         blankAppMakeModel=true;
        }
    }
    public map<String,List<CSS_Fault_Code__c>> getMapforfaultcodes(List<CSS_Fault_Code__c> faultCodes){
        map<String,List<CSS_Fault_Code__c>> mapModfc = new map<String,List<CSS_Fault_Code__c>>();            
        for(CSS_Fault_Code__c fc:faultCodes){
            if(mapModfc.containsKey(fc.Mod__c)){
                mapModfc.get(fc.Mod__c).add(fc);
            }else{
                List<CSS_Fault_Code__c> fclist = new List<CSS_Fault_Code__c>{fc};
                mapModfc.put(fc.Mod__c,fclist);
            }
        }    
        System.debug('Method*** 15');
        return mapModfc;
    }   
    public String selectedFaulcode{set;get;}
    public String selectedReltdFaulcode{set;get;}
    public List<CSS_JobEventTemporary__c> qsolRetrivedFCMasters {set;get;}
    public CSS_JobEventTemporary__c qsolRetrivedFCMaster {set;get;}  




    public PageReference faultCodeClick(){
        PageReference pageRef;
        string redirect; 
        system.debug('@@@@pageName'+pageName);
        if(pageName.equalsIgnoreCase('TND')){
            redirect='/apex/CSS_JobTndEds?id='+Ins_JobId+'&fcid='+selectedFaulcode;
        }
        system.debug('*****%%%%'+redirect);

        if(pageName.equalsIgnoreCase('REPAIR')){
            system.debug('after'+redirect);
            redirect='/apex/CSS_JobRepairEDS?pgFlag=RM&id='+Ins_JobId+'&fcid='+selectedFaulcode;

        }
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }  
    public PageReference invokeLaunchInsite(){
        PageReference pageRef = null;
        // do here
        return pageRef;        
    }
    //BEGIN - Code For Solutions, Components & SRT
    public Transient List<CSS_Solutions__c> lstSolsForFC; //For Solutions, Components & SRT
    public List<CSS_Solution_Component__c> lstCompForSol; //For Solutions, Components & SRT
    public List<CSS_SRT__c> lstSRTForFC; //For Solutions, Components & SRT
    public List<CSS_Fault_Code__c> lstFC = new List<CSS_Fault_Code__c>();

    public map<String,List<CSS_Solutions__c>> getAllSolDetails() {
        Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        List<CSS_Solutions__c> lstSols;
        if (!lstSolsForFC.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForFC) {

                if(mapSolutions.containsKey(recSolWFC.FaultCode__r.Id)) {
                    mapSolutions.get(recSolWFC.FaultCode__r.Id).add(recSolWFC);
                } else {
                    lstSols = new List<CSS_Solutions__c>{recSolWFC};
                    mapSolutions.put(recSolWFC.FaultCode__r.Id, lstSols);
                }
            } 
        }
        return mapSolutions;
    }
    public map<String,List<CSS_Solutions__c>> getVerSolDetails() {
        Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        List<CSS_Solutions__c> lstSols = new List<CSS_Solutions__c>();
        if (!lstSolsForFC.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForFC) {
                if(recSolWFC.rank__c != null)
                    recSolWFC.rank__c = recSolWFC.rank__c+1;
                // if (recSolWFC.Diagnostic_Response__c=='Most likely the solution') {
                if(mapSolutions.containsKey(recSolWFC.FaultCode__r.Id)) {
                    mapSolutions.get(recSolWFC.FaultCode__r.Id).add(recSolWFC);
                } else {
                    lstSols = new List<CSS_Solutions__c>{recSolWFC};
                    mapSolutions.put(recSolWFC.FaultCode__r.Id, lstSols);
                }
                // }
            } 
        }
        //Generate a Blank Record for List
        CSS_Solutions__c recSolution  = new CSS_Solutions__c(name='');
        List<CSS_Solutions__c> lstEmptySols = new List<CSS_Solutions__c>{recSolution};
        if (!lstFC.IsEmpty()) {
            for (CSS_Fault_Code__c recFC : lstFC) {
                if (!mapSolutions.containsKey(recFC.id)){
                    mapSolutions.put(recFC.id, lstEmptySols);
                }
            }
        }
        return mapSolutions;
    }

    //added for defect 109207

    Map<String,Integer> mapRank = new  Map<String,Integer>();
    Map<String,Integer> mapRanking { get; set; }

    public map<String,Integer> getrankDetails() {    
        for(CSS_Fault_Code__c qA1: lstFC ){
            String rankdetail=null;
            if(qA1.CSS_Solutions__r!=null && !qA1.CSS_Solutions__r.isEmpty()){

                // Satish Code for setting Rank
                // Scenario-1 get least available solution rank
                Boolean BreakFlag = false;

                for(integer i=0;i<qA1.CSS_Solutions__r.size();i++)
                {        
                    for(integer j=0;j<qA1.CSS_Solutions__r.size();j++)
                    {
                        if(Integer.ValueOf(qA1.CSS_Solutions__r[j].Rank__c)==i)
                        {
                            if(qA1.CSS_Solutions__r[j].Diagnostic_Response__c==null)
                            {
                                rankdetail =String.ValueOf(qA1.CSS_Solutions__r[j].Rank__c);
                                BreakFlag=true;
                                break;
                            }
                        }
                    }
                    if(BreakFlag==true) break;
                }

                // Scenario-2 get last updated solution rank
                if(rankdetail==null)
                {
                    rankdetail=String.ValueOf(qA1.CSS_Solutions__r[qA1.CSS_Solutions__r.size()-1].Rank__c);
                }

                // end Satish Code for setting Rank 


                mapRank.put(qA1.Id, Integer.ValueOf(rankdetail));
                //System.debug('shanu mapRank3-->'+mapRank);
                mapRanking=mapRank;

            }

        }
        System.debug('shanu mapRank4-->'+mapRanking);
        return mapRanking;

    }
    //END

    public map<String,List<CSS_Solution_Component__c>> getRepairDetails() {
        Map<String,List<CSS_Solution_Component__c>> mapCompo = new  Map<String,List<CSS_Solution_Component__c>>();
        List<CSS_Solution_Component__c> lstComps;
        if (!lstCompForSol.IsEmpty()) {
            for(CSS_Solution_Component__c recCompFSol : lstCompForSol) {
                //if (recCompFSol.Action__c=='') {
                if(mapCompo.containsKey(recCompFSol.Solutions__c)) {
                    mapCompo.get(recCompFSol.Solutions__c).add(recCompFSol);
                } else {
                    lstComps = new List<CSS_Solution_Component__c>{recCompFSol};
                    mapCompo.put(recCompFSol.Solutions__c, lstComps);
                }
                //}
            } 
        }
        //Generate a Blank Record for List
        CSS_Solution_Component__c recComponent  = new CSS_Solution_Component__c(name='');
        List<CSS_Solution_Component__c> lstEmptyComps = new List<CSS_Solution_Component__c>{recComponent};
        if (!lstSolsForFC.IsEmpty()) {
            for (CSS_Solutions__c recSOL : lstSolsForFC) {
                if (!mapCompo.containsKey(recSOL.id)){
                    mapCompo.put(recSOL.id, lstEmptyComps);
                }
            }
        }
        return mapCompo;
    }

    //Below method Added for coco sprint saikomal
    public map<String,List<CSS_Parts_Options__c>> getPartDetails() {
        system.debug('Inside parts Details');
        Transient Map<String,List<CSS_Parts_Options__c>> mapParts = new  Map<String,List<CSS_Parts_Options__c>>();
        Transient List<CSS_Parts_Options__c> lstPartsComp;
        if (!lstCompForSol.IsEmpty()) {
            for(CSS_Solution_Component__c recCompFSol : lstCompForSol) {
                system.debug('Inside Repair Details comp '+ recCompFSol.Id);
                system.debug('Inside Repair Details parts '+ recCompFSol.CSS_Parts_Options__r);
                if(!recCompFSol.CSS_Parts_Options__r.IsEmpty() ){
                    for(CSS_Parts_Options__c p: recCompFSol.CSS_Parts_Options__r){
                        if(p.FailurepartId__c == recCompFSol.Id){
                            system.debug('Inside Parts IF');

                            if(mapParts.containsKey(p.FailurepartId__c)) {
                                mapParts.get(p.FailurepartId__c).add(p);
                            } else {
                                lstPartsComp = new List<CSS_Parts_Options__c>{p};
                                mapParts.put(p.FailurepartId__c,lstPartsComp);
                            }
                            //lstPartsComp = new List<CSS_Parts_Options__c>{p};
                            //mapParts.put(recCompFSol.Id, lstPartsComp);
                        }

                        system.debug('mapParts Inside 1st For Loop--->'+mapParts);

                    }
                }
            }

            //system.debug('lstParts--->'+lstParts);
            system.debug('lstPartsComp--->'+lstPartsComp);
            system.debug('mapParts--->'+mapParts);
            //system.debug('mapCompo--->'+mapCompo);
        }
        //Generate a Blank Record for List
        CSS_Parts_Options__c recPart  = new CSS_Parts_Options__c(name='');
        Transient List<CSS_Parts_Options__c> lstEmptyParts = new List<CSS_Parts_Options__c>{recPart};
        if (!lstCompForSol.IsEmpty()) {
            for (CSS_Solution_Component__c recSOLComp : lstCompForSol) {
                system.debug('mapParts Inside 2nd For Loop recSOLComp-->'+recSOLComp.Id);
                if (!mapParts.containsKey(recSOLComp.id)){
                    mapParts.put(recSOLComp.id, lstEmptyParts);
                }
                system.debug('mapParts Inside 2nd For Loop--->'+mapParts);
            }
        }
        system.debug('mapParts111--->'+mapParts);
        return mapParts;
    }
    //end
    public map<String,String> getDiagSRTDetails() {
        List<Decimal> lstDiagSRT1;
        List<Decimal> lstDiagSRT2;
        Map<String,List<Decimal>> mapDiagSRT = new  Map<String,List<Decimal>>();
        Map<String,String> mapsDiaSRT = new  Map<String,String>();
        Decimal dDiagTime;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        String sDTime;
        if (!lstSRTForFC.isEmpty()){
            for(CSS_SRT__c recSRTWFC : lstSRTForFC) {
                if (recSRTWFC.Type__c == 'Diagnosis'){
                    if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.FaultCode__r.Id)) {
                        mapDiagSRT.get(recSRTWFC.Solution_Number__r.FaultCode__r.Id).add(recSRTWFC.Diagnosis_Time__c);
                    } else {
                        lstDiagSRT1 = new List<Decimal>{recSRTWFC.Diagnosis_Time__c};
                        mapDiagSRT.put(recSRTWFC.Solution_Number__r.FaultCode__r.Id, lstDiagSRT1);
                    }                   
                }
            }
            for (String FCId: mapDiagSRT.keyset()){
                lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                dDiagTime = 0.0;
                sDTime = '';
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
                        if(dTime!=null)
                            dDiagTime = dDiagTime + dTime;
                    }
                }
                mapsDiaSRT.put(FCId,string.valueof(dDiagTime));
            }
        }
        //Generate a Blank Record for List
        if (!lstFC.IsEmpty()) {
            for (CSS_Fault_Code__c recFC : lstFC) {
                if (!mapsDiaSRT.containsKey(recFC.id)){
                    mapsDiaSRT.put(recFC.id, '');
                }
            }
        }       
        return mapsDiaSRT;
    } 
    public map<String,String> getRepSRTDetails() {
        List<Decimal> lstDiagSRT1;
        List<Decimal> lstDiagSRT2;
        Map<String,List<Decimal>> mapDiagSRT = new  Map<String,List<Decimal>>();
        Map<String,String> mapsDiaSRT = new  Map<String,String>();
        Decimal dDiagTime;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        String sDTime;
        if (!lstSRTForFC.isEmpty()){
            for(CSS_SRT__c recSRTWFC : lstSRTForFC) {
                if (recSRTWFC.Type__c == 'Repair' && recSRTWFC.isPerformed__c == true){
                    if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.FaultCode__r.Id)) {
                        if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                            mapDiagSRT.get(recSRTWFC.Solution_Number__r.FaultCode__r.Id).add(recSRTWFC.Repair_Time__c);
                        }
                    } else {
                        lstDiagSRT1 = new List<Decimal>{recSRTWFC.Repair_Time__c};
                        if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                            mapDiagSRT.put(recSRTWFC.Solution_Number__r.FaultCode__r.Id, lstDiagSRT1);
                        }
                    }                   
                }
            }
            for (String FCId: mapDiagSRT.keyset()){
                lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                dDiagTime = 0.0;
                sDTime = '';
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
                        if(dTime != null)
                            dDiagTime = dDiagTime + dTime;
                    }
                }
                mapsDiaSRT.put(FCId,string.valueof(dDiagTime));
            }
        }
        //Generate a Blank Record for List
        if (!lstFC.IsEmpty()) {
            for (CSS_Fault_Code__c recFC : lstFC) {
                if (!mapsDiaSRT.containsKey(recFC.id)){
                    mapsDiaSRT.put(recFC.id, '0.0');
                }
            }
        }
        return mapsDiaSRT;
    }
    public void getSolutions(){
        List<CSS_Fault_Code__c> fc= new List<CSS_Fault_Code__c>();
        fc = [select id,name,DSID__c,Job_Order__c from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
        Map<ID,ID>  jobOrder = new Map<ID,ID>();
        Map<ID,String> faultCode = new Map<ID,String>();
        for(integer i=0;i<fc.size();i++){
            jobOrder.put(fc[i].id,fc[i].Job_Order__c);
            faultCode.put(fc[i].id,fc[i].name); 
        }
        System.debug('The job order is'+jobOrder);
        System.debug('The faultCode is'+faultCode);
    }
    //END - Code For Solutions, Components & SRT 

    public static void UpdateGTIS(List<Id> jobIds,Integer mType){

        System.debug('TUpdateGTIS'+jobIds+mType);
        List<css_job_order__c> lstJo = new List<css_job_order__c>();
        List<css_job_order__c> joUpdate = [Select Name,Id,Status__c from css_job_order__c where Id=:jobIds];

        for ( css_job_order__c ju:joUpdate){            
            if (mType == 1){                
                ju.Previous_Status__c =ju.Status__c;
                ju.Status__c ='Not Supported';
                ju.GTIS_Message_Type__c =1;
                lstJo.add(ju);
                System.debug('Inside 1 '+ju);
            }

            if (mType == 2){                
                ju.GTIS_Message_Type__c =2;
                lstJo.add(ju);
                System.debug('Inside 2 '+ju);
            }            
        }
        update lstJo;
    }

    public string rank{get;set;}
    public PageReference repsol1(){

        PageReference pageRef;
        string redirect='/apex/CSS_JobRepairEDSV1?id='+Ins_JobId+'&fcid='+selectedFaulcode+'&rank='+rank;
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }   
    //Story 67558
    public PageReference takeControl(){
        PageReference pageRef;
        try{
            System.debug('Start takeControl DSID is '+rJobOrd.DSID__c);
            if(rJobOrd.DSID__c!=null){
                CSS_WS_EDS.unlockDsid(rJobOrd.DSID__c);
            }
            String FedId = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
            CSS_EDSAuthentication.getTCUpdate(rJobOrd.DSID__c, FedId, rJobOrd.Customer_Name__c, rJobOrd.Make__c, rJobOrd.Model__c, rJobOrd.AccessCode__c, rJobOrd.Equipment_ID__c, rJobOrd.Mileage__c, rJobOrd.Mileage_Measure__c, rJobOrd.Unit_Number__c,rJobOrd.ESN__c,rJobOrd.Shop_Work_Order__c);//Changes done as per Defect 183636 by Akanksha
            //css_utility.updateDSID(rJobOrd.DSID__c, u3.FederationIdentifier, rJobOrd.Customer_Name__c, rJobOrd.Make__c, rJobOrd.Model__c, rJobOrd.AccessCode__c, rJobOrd.Equipment_ID__c, rJobOrd.Failure_Point__c, rJobOrd.Failure_Point_Measure__c, rJobOrd.Unit_Number__c,rJobOrd.ESN__c,rJobOrd.Shop_Work_Order__c);
            //rJobOrd.DSID_Owner__c = u3.FederationIdentifier;
            rJobOrd.DSID_Owner__c = FedId;
            //            update rJobOrd;
            System.debug('Exit takeControl DSID is '+rJobOrd.DSID__c);
            // ==== Call DsidInticator == 
            //dsidIndi = css_utility.getDSIDEditIndicator(userinfo.getUserId(),rJobOrd.DSID__c, rJobOrd.DSID_WorkGroup__c);
            String dsOwner = CSS_WS_EDS.getDSIDDetails(rJobOrd.DSID__c, 'en');
            system.debug('DSID OWNER from EDS -->'+dsOwner);
            if(dsOwner == FedId){
                dsIndicator = 'O';
            }
            else //Logged in user is not DSID owner
            {
                if ((String)Cache.Session.get('local.CSSPartition.UserEDSWorkGroupName') == rJobOrd.DSID_WorkGroup__c) // Logged in User WG is same as Job WG
                    dsIndicator = 'G';
                else dsIndicator = 'N'; // Logged in User WG is not same as Job WG
            }
            update rJobOrd;
            system.debug('Before Cache');
            Cache.Session.put('local.CSSPartition.DSIDIndicator', dsIndicator);
            system.debug('Before Cache');
            PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl().substringBefore('?')+'?id='+Ins_JobId);
            //string redirectPg='/apex/CSS_JobRepair?id='+Ins_JobId;
            //ReturnPage = new PageReference(ReturnPage);            
            ReturnPage.setRedirect(true);
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError('Take Control - DSID',e.getMessage()+'-DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError('Take Control - DSID',e.getMessage()+'-DSID', 'Error In Response', 'EDS');
                }
            }
        }
        return pageRef;
    }

    /*** Method*** to make a ws call to BMS for Unit lookup and show them in a POP UP ***/
    public Boolean bmsUnitLookupPopup;
    public CSS_UnitOutboundJSON2Apex UnitOutboundDetails{get;set;}
    public void getBMSUnitDetails(String ESN){

        try{   UnitOutboundDetails = new CSS_UnitOutboundJSON2Apex();
            //making a callout to get the details
            CSS_FN_BMS BMSFunctionality = new CSS_FN_BMS();
            if(rJobOrd.Customer_Code__c!= null && rJobOrd.Customer_Code__c != '')
                UnitOutboundDetails = BMSFunctionality.getBMSUnitLookupDetails(rJobOrd.Customer_Code__c,(ESN == null ? '' : ESN),'',rJobOrd.Creator_Location__c);
            System.debug('UnitOutboundDetails********'+UnitOutboundDetails);
            if(UnitOutboundDetails.DataArea!=null){
                UnitLookUpPopup=true;
            }else{
                woInESN.Unit_Type__c = '';
            }
            if( UnitOutboundDetails != null && UnitOutboundDetails.Header.Status == 'ERROR'){
                system.debug('Entered If Unit Outbound- Anirudh');
                woInESN.BMSStatus__c = rJobOrd.BMSStatus__c + ',' + 'UO1';
                woInESN.Unit_Number__c = '';
                woInESN.Unit_Type__c = '';
            }
           }
        catch( exception e){
            System.debug('Exception in CSS_WS_BMS.callUnitOutboundService'+e);
        }
    }
    public Boolean UnitLookUpPopup{get;set;}
    public String selectedUnitNumber{get;set;}
    public void selectedBMSUnitNumber(){
        system.debug('selBMSUnitNumber [[[[[[[[[[[[[[[[[[[]]]]]]]]]]]');
        //selectedUnitNumber = System.currentPagereference().getParameters().get('BMSUnitNumber');
        system.debug('selectedUnitNumber '+ selectedUnitNumber);             
    }
    /**** Method*** To Display the Selected Unit Number from Pop Up ***********/
    public PageReference selectedUnitDetails(){
        try{
            UnitLookUpPopup=false; 
            system.debug('selectedUnitNumber: '+selectedUnitNumber);
            if(selectedUnitNumber != null && selectedUnitNumber != ''){
                system.debug('selectedUnitNumber: '+UnitOutboundDetails.DataArea);
                if ( UnitOutboundDetails.DataArea != null && !UnitOutboundDetails.DataArea.isEmpty() ) {
                    for(CSS_UnitOutboundJSON2Apex.DataArea ud:UnitOutboundDetails.DataArea){
                        system.debug('inside Loop: '+ud.UnitNumber);
                        if(selectedUnitNumber == ud.UnitNumber ){                
                            system.debug('inside Loop Id: '+ud.CustomerCode);
                            woInESN.Unit_Number__c = ud.UnitNumber;
                            woInESN.Unit_Type__c = ud.UnitType; // added code for story 102591
                            bmsUnitLookupPopup = true;
                        }
                    }
                }
                update woInESN; 
            }
        }catch(exception e){
            system.debug('Entered into Catch block of selectedUnitDetails in CSS_TnDRepoverController>>>>>>>>'+e.getMessage()+''+e.getLineNumber());
        }
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        PageReference pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
        pageRef.setRedirect(true);
        return PageRef; 
    }
    public void closeBMSUnitDetails(){
        UnitLookUpPopup=false;
    }
    /******** End Unit Lookup WebService and PopUp Method***s *****/ 

    /******** Dsid Create And calling Unit lookup Generic Method*** *****/
    public void createDSIDAndBMSLookup(){
        System.debug('entered into createDSIDAndBMSLookup...');
        try{
            //bmsEnabled = css_utility.getBMSEnabled(userinfo.getUserId());
            bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
            //css_job_order__c woInESN= new css_job_order__c();
            woInESN.ESN__c = rJobOrd.ESN_Insite__c;
            System.debug('entered into Create DSID...rJobOrd.ESN_Insite__c>>>>>>>:'+rJobOrd.ESN_Insite__c+' Customer_Name__c>>>:'+rJobOrd.Customer_Name__c);
            //Create DSID
            if( rJobOrd.DSID__c == null && woInESN.ESN__c != null && rJobOrd.Customer_Name__c != null && rJobOrd.Customer_Name__c != null && ((!String.isEmpty(woInESN.Application_Desc__c)) && (rJobOrd.Application_Desc__c!='Select One' && rJobOrd.Application_Desc__c!=null && rJobOrd.Application_Desc__c!='')) && ((woInESN.Make__c != null && woInESN.Make__c != '') && (rJobOrd.Make__c!='Select One' && rJobOrd.Make__c!=null && rJobOrd.Make__c!='' && rJobOrd.Make__c!='----Select One ----' && rJobOrd.Make__c!='----None----')) && ((woInESN.Model__c!=null && woInESN.Model__c != '') && (rJobOrd.Model__c!='Select One' && rJobOrd.Model__c!=null && rJobOrd.Model__c!='' && rJobOrd.Model__c!='----Select One ----' && rJobOrd.Model__c!='----None----'))){
                 blankAppMakeModel=false;
                system.debug('Entered into Create DSID - Anirudh');
                DSID = CSS_EDSAuthentication.getDSID(woInESN.ESN__c,rJobOrd.Name,rJobOrd.Application_Desc__c,rJobOrd.Unit_Number__c,rJobOrd.Mileage__c,
                                                     rJobOrd.Mileage_Measure__c,rJobOrd.Make__c,rJobOrd.Model__c,rJobOrd.Equipment_ID__c,rJobOrd.Customer_Name__c,
                                                     rJobOrd.Service_Model__c,rJobOrd.Shop_Work_Order__c,rJobOrd.AccessCode__c); 
                woInESN.DSID__c = DSID;
                woInESN.DSID_Creation_Timestamp__c = System.now();
                woInESN.DSID_Status__c = 'Open';
                //woInESN.DSID_WorkGroup__c = u3.Work_Group_Name__c; 
                woInESN.DSID_WorkGroup__c = (String)Cache.Session.get('local.CSSPartition.UserEDSWorkGroupName');
                //woInESN.DSID_Owner__c = u3.FederationIdentifier;
                woInESN.DSID_Owner__c = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
                //Story Number - 71586
                woInESN.ESN_Locked__c = TRUE;
                //End
            }  else{
               blankAppMakeModel=true;
            }
            system.debug('woInESN.DSID__c>>>>>>'+woInESN.DSID__c);
            //End DSID
            //To call Unit lookup Service if the user is a BMS user
            if(bmsEnabled==true){
                system.debug('$$$$$$$$$$$$ rJobOrd.ESN__c-->'+rJobOrd.ESN__c);
                if(rJobOrd.ESN__c!=null && rJobOrd.ESN__c!='')
                    getBMSUnitDetails(rJobOrd.ESN_Insite__c);
                else if(rJobOrd.ESN_Insite__c !=null && rJobOrd.ESN_Insite__c!='')
                    getBMSUnitDetails(rJobOrd.ESN_Insite__c);
            }
            //End Call Unit Lookup Service
            System.debug('$$$$$$$$$$$$$$$$$$Inside system esn-4');
            woInESN.id=rJobOrd.id;
            if(woInESN.DSID__c!=null){
                System.debug('$$$$$$$$$$$$$$$$$$$$$Inside system esn-5');
                solutionNumber(woInESN.DSID__c);
            } 

        }catch(Exception ex){
            System.debug('enterd into Catch of createDSIDAndBMSLookup... ExnNo:>>>>>>>>>>>>>:'+ex.getLineNumber()+' Exception Msg>>>>>>:'+ex.getMessage());
        }
    }
    /******** END Dsid Create And calling Unit lookup Generic Method*** *****/

    /******** Generic Method*** For Create DSID and BMS Lookup from pgFCRefresh method *********/
    /******** Couldnt use the createDSIDAndBMSLookup as conditions were different so had to create new Method*********/
    public boolean blnFcCodeAvl = false;
    public List<faultcodeswrapper> fcwrap;
    public void createDSIDAndBMSLookupInPgFcRefresh(){
        try{
            fcwrap = getFCWrapper();
            //EDS Analytics - Fault Code
            // AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
            // integer maxSeq = integer.valueOf(sequence [0].get('maxSeq'));
            //List<CSS_Fault_Code__c> fauCod = [select Name,Related_Fault_Code__c from CSS_Fault_Code__c where Sequence__c=:maxSeq and Job_Order__c=:Ins_JobId  and (Fault_Code_Type__c='APD-P' OR Fault_Code_Type__c='APD-R' OR Fault_Code_Type__c='BPD') limit 5];
            //CSS_EDSActionsUpdate.insiteFaultCodes(fauCod,rJobOrd.DSID__c);
            /* BEGIN - Defect Fix - 50087 - Two popup's were being shown */
            //List<faultcodeswrapper> fcUpCodes = getUnprioritizedFCWrapper();
            // Boolean blnFcCodeAvl = false;
            System.debug('outside if condition');
            if( rJobOrd.DSID_WorkGroup__c != null && rJobOrd.DSID__c!=null ){

                System.debug('call ExitDSID WebServicecalled ParamterinIFFFF>>>>>>>>>'+rJobOrd.DSID_WorkGroup__c+''+rJobOrd.DSID__c);
                System.debug('call getEXITDSID WebServicecalled>>>>>>>>>');
                // CSS_EDSAuthentication.exitDSID(rJobOrd.DSID_WorkGroup__c,rJobOrd.DSID__c);
            }
            if ((fcwrap.size() > 0) )
            {   
                System.debug('in if condition');
                blnFcCodeAvl = true;
                System.debug('The checkSol value outside if is'+checkSol + ' '+ JobData.DSID__c + ' '+JobData.ESN__c+ ' '+JobData.Customer_Name__c+ ' '+JobData.ESN_Insite__c);
                if(checkSol==false){
                    //Defect fix - Pop up is not getting showed up for different esn - 75924
                    if(JobData.DSID__c == null && JobData.ESN__c != null && JobData.Customer_Name__c != null && JobData.ESN__c == JobData.ESN_Insite__c && ( !String.isEmpty(woInESN.Application_Desc__c) && !String.isEmpty(JobData.Application_Desc__c) && JobData.Application_Desc__c !='Select One') && (!String.isEmpty(woInESN.Make__c) && !String.isEmpty(JobData.Make__c) && JobData.Make__c != 'Select One' && JobData.Make__c != '----Select One ----' && JobData.Make__c != '----None----')  && (!String.isEmpty(woInESN.Model__c) &&  !String.isEmpty(JobData.Model__c) && JobData.Model__c != 'Select One' && JobData.Model__c != '----Select One ----' && JobData.Model__c != '----None----')){
                        system.debug('Entered DSID Create>>>>>>');
                        DSID = CSS_EDSAuthentication.getDSID(JobData.ESN__c,JobData.Name,JobData.Application_Desc__c,JobData.Unit_Number__c,JobData.Mileage__c,
                                                             JobData.Mileage_Measure__c,JobData.Make__c,JobData.Model__c,JobData.Equipment_ID__c,JobData.Customer_Name__c,
                                                             JobData.Service_Model__c,JobData.Shop_Work_Order__c,JobData.AccessCode__c);  
                        woInESN.DSID__c = DSID;
                        woInESN.DSID_Creation_Timestamp__c = System.now();
                        woInESN.DSID_Status__c = 'Open';
                        //woInESN.DSID_WorkGroup__c = u3.Work_Group_Name__c;
                        woInESN.DSID_WorkGroup__c = (String)Cache.Session.get('local.CSSPartition.UserEDSWorkGroupName');
                        //woInESN.DSID_Owner__c = u3.FederationIdentifier;
                        woInESN.DSID_Owner__c = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
                        woInESN.ESN_Locked__c = true;
                    }
                    checkSol = true;
                    // AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
                    // integer maxSeq = integer.valueOf(sequence [0].get('maxSeq'));
                    /* List<CSS_Fault_Code__c> fc= new List<CSS_Fault_Code__c>();
fc = [select id,name,DSID__c,Job_Order__c,Number_of_Solutions__c from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId and Sequence__c=:maxSeq];
Map<ID,ID>  jobOrder = new Map<ID,ID>();
Map<ID,String> faultCode = new Map<ID,String>();
for(integer i=0;i<fc.size();i++){
if(fc[i].Number_of_Solutions__c==null){
jobOrder.put(fc[i].id,fc[i].Job_Order__c);
faultCode.put(fc[i].id,fc[i].name); 
dsid = fc[0].dsid__c;
}
}
string language = 'en';
System.debug('The dsid is'+rJobOrd.DSID__c);
if(rJobOrd.DSID__c!=null){
CSS_EDSAuthentication.getFaultCodeSearch(jobOrder, faultCode,rJobOrd.DSID__c,aLang.CSS_EDSLanguage__c); 
}*/
                    /**** Making BMS WebService Call ****/
                    system.debug('Anirudh>>>>>>>>>>>'+rJobOrd.PSN_Not_Available__c + ' ' + JobData.ESN_Insite__c);
                    if(rJobOrd.PSN_Not_Available__c==true && bmsEnabled == true){
                        system.debug('Anirudh>>>>>>>>>>>'+rJobOrd.PSN_Not_Available__c + ' ' + JobData.ESN_Insite__c);
                        getBMSUnitDetails(JobData.ESN_Insite__c);
                    }
                    if(woInESN.DSID__c!=null){
                        solutionNumber(woInESN.DSID__c);
                    }
                    else if(JobData.DSID__c != null){
                        solutionNumber(JobData.DSID__c);
                    }
                    System.debug('The checkSol value inside if is'+checkSol);

                }
                System.debug('The checkSol value outside if one is'+checkSol);
            }
        }catch(exception e){
            system.debug('Entered into catch block of createDSIDAndBMSLookupInPgFcRefresh in CSS_TndRepoverController' +e.getMessage() + ' ' + e.getLineNumber());
        }
    }
    /******** END Generic Method*** For Create DSID and BMS Lookup from pgFCRefresh method *********/
    
     public void createDSIDAndBMSLookupInPgFcRefresh1(){
        try{
        fcwrap = getFCWrapper();
            //EDS Analytics - Fault Code
            // AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
            // integer maxSeq = integer.valueOf(sequence [0].get('maxSeq'));
            //List<CSS_Fault_Code__c> fauCod = [select Name,Related_Fault_Code__c from CSS_Fault_Code__c where Sequence__c=:maxSeq and Job_Order__c=:Ins_JobId  and (Fault_Code_Type__c='APD-P' OR Fault_Code_Type__c='APD-R' OR Fault_Code_Type__c='BPD') limit 5];
            //CSS_EDSActionsUpdate.insiteFaultCodes(fauCod,rJobOrd.DSID__c);
            /* BEGIN - Defect Fix - 50087 - Two popup's were being shown */
            //List<faultcodeswrapper> fcUpCodes = getUnprioritizedFCWrapper();
            // Boolean blnFcCodeAvl = false;
            System.debug('outside if condition');
            if( rJobOrd.DSID_WorkGroup__c != null && rJobOrd.DSID__c!=null ){
                
                System.debug('call ExitDSID WebServicecalled ParamterinIFFFF>>>>>>>>>'+rJobOrd.DSID_WorkGroup__c+''+rJobOrd.DSID__c);
                System.debug('call getEXITDSID WebServicecalled>>>>>>>>>');
                // CSS_EDSAuthentication.exitDSID(rJobOrd.DSID_WorkGroup__c,rJobOrd.DSID__c);
            }
         if ((fcwrap.size() > 0) )
            {   
                System.debug('in if condition');
                blnFcCodeAvl = true;
                System.debug('The checkSol value outside if is'+checkSol + ' '+ JobData.DSID__c + ' '+JobData.ESN__c+ ' '+JobData.Customer_Name__c+ ' '+JobData.ESN_Insite__c);
                System.debug('The checkSol value outside if is application' + ' '+ JobData.Application_Desc__c + 'Job Make'+JobData.Make__c+ ' Job Model '+JobData.Model__c+ 'insite esn '+JobData.ESN_Insite__c+'insite'+woInESN.Application_Desc__c +'insite make'+woInESN.Make__c +'insite model'+woInESN.Model__c);
                if(checkSol==false){
                    //Defect fix - Pop up is not getting showed up for different esn - 75924
                    if(JobData.DSID__c == null && JobData.ESN__c != null && JobData.Customer_Name__c != null && JobData.ESN__c == JobData.ESN_Insite__c &&  (!String.isEmpty(JobData.Application_Desc__c) && JobData.Application_Desc__c !='Select One')  && (!String.isEmpty(JobData.Make__c) && JobData.Make__c != 'Select One' && JobData.Make__c != '----Select One ----' && JobData.Make__c != '----None----')  && (!String.isEmpty(JobData.Model__c) && JobData.Model__c != 'Select One' && JobData.Model__c != '----Select One ----' && JobData.Model__c != '----None----')){
                        system.debug('Entered DSID Create>>>>>>');
                        DSID = CSS_EDSAuthentication.getDSID(JobData.ESN__c,JobData.Name,JobData.Application_Desc__c,JobData.Unit_Number__c,JobData.Mileage__c,
                                                             JobData.Mileage_Measure__c,JobData.Make__c,JobData.Model__c,JobData.Equipment_ID__c,JobData.Customer_Name__c,
                                                             JobData.Service_Model__c,JobData.Shop_Work_Order__c,JobData.AccessCode__c);  
                        woInESN.DSID__c = DSID;
                        woInESN.DSID_Creation_Timestamp__c = System.now();
                        woInESN.DSID_Status__c = 'Open';
                        //woInESN.DSID_WorkGroup__c = u3.Work_Group_Name__c;
                        woInESN.DSID_WorkGroup__c = (String)Cache.Session.get('local.CSSPartition.UserEDSWorkGroupName');
                        //woInESN.DSID_Owner__c = u3.FederationIdentifier;
                        woInESN.DSID_Owner__c = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
                        woInESN.ESN_Locked__c = true;
                    }
                    checkSol = true;
                    // AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
                    // integer maxSeq = integer.valueOf(sequence [0].get('maxSeq'));
                    /* List<CSS_Fault_Code__c> fc= new List<CSS_Fault_Code__c>();
fc = [select id,name,DSID__c,Job_Order__c,Number_of_Solutions__c from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId and Sequence__c=:maxSeq];
Map<ID,ID>  jobOrder = new Map<ID,ID>();
Map<ID,String> faultCode = new Map<ID,String>();
for(integer i=0;i<fc.size();i++){
if(fc[i].Number_of_Solutions__c==null){
jobOrder.put(fc[i].id,fc[i].Job_Order__c);
faultCode.put(fc[i].id,fc[i].name); 
dsid = fc[0].dsid__c;
}
}
string language = 'en';
System.debug('The dsid is'+rJobOrd.DSID__c);
if(rJobOrd.DSID__c!=null){
CSS_EDSAuthentication.getFaultCodeSearch(jobOrder, faultCode,rJobOrd.DSID__c,aLang.CSS_EDSLanguage__c); 
}*/
                    /**** Making BMS WebService Call ****/
                    system.debug('Anirudh>>>>>>>>>>>'+rJobOrd.PSN_Not_Available__c + ' ' + JobData.ESN_Insite__c);
                    if(rJobOrd.PSN_Not_Available__c==true && bmsEnabled == true){
                        system.debug('Anirudh>>>>>>>>>>>'+rJobOrd.PSN_Not_Available__c + ' ' + JobData.ESN_Insite__c);
                        getBMSUnitDetails(JobData.ESN_Insite__c);
                    }
                    if(woInESN.DSID__c!=null){
                        solutionNumber(woInESN.DSID__c);
                    }
                    else if(JobData.DSID__c != null){
                        solutionNumber(JobData.DSID__c);
                    }
                    System.debug('The checkSol value inside if is'+checkSol);
                    
                }
                System.debug('The checkSol value outside if one is'+checkSol);
            }
        }catch(exception e){
            system.debug('Entered into catch block of createDSIDAndBMSLookupInPgFcRefresh in CSS_TndRepoverController' +e.getMessage() + ' ' + e.getLineNumber());
        }
    }

    /******** Start Request Method*** to get engine data plate on Change of ESN through Insite***********/
    public string sEngineFamilyCode {get; set;}
    public string sServiceModel {get; set;}
    public date siebelWarrantyDate=null;
    public String filterMake;
    public String filterModel;
    // public date siebelWarrantyDate;
    public String siebelSMN;
    public string siebVIN;
    public string siebAppCode;
    public string siebMake;
    public string siebModel;
    public boolean HHSPSMNFlg{get;set;}
    public boolean HHSPACCSFlg{get;set;}
    public Boolean displaySrvModPopup {get;set;}
    public Boolean displayHHPPopup1 {get;set;}
    public Boolean displayHHPPopup2 {get;set;}
    public void  startRequest(String ESN,String HHPPopUp) {
        //CSS_quickserveCumminsComWebservices.ModelName rDataPlate = new CSS_quickserveCumminsComWebservices.ModelName();  
        CSS_getEngineDataResponseJ2A rDataPlate = new CSS_getEngineDataResponseJ2A(); //GSSC_97, ROD:Qsol changes
        CSS_getEngineDataResponseJ2A  engineData;
        try{
            JobData = [Select Id,creator_location__c,PSN_Not_Available__c,Failure_Date__c,SPDataWebserviceResult__c,Name,Insite_ESN2__c,Insite_ESN2_Select__c,ESN_Locked__c,ESN_Insite__c,DSID__c,ESN__c,Customer_Name__c,Application__c,Unit_Number__c,Mileage__c,Mileage_Measure__c,Make__c,Model__c,Equipment_ID__c,Service_Model__c,Shop_Work_Order__c,AccessCode__c,Application_Desc__c from CSS_Job_Order__c where id= :rJobOrd.Id];

            system.debug('StartRequest>>>');
            siebelWarrantyDate=null;
            woInESN.VIN__c = '';
            if (ESN =='' || ESN ==null){
                woInESN.Service_Model__c = '';
                woInESN.VIN__c = '';
                woInESN.Warranty_Start_Date__c =null;
                woInESN.Location_Certification__c='';
                // rJobOrd.Application__c='';
                sEngineFamilyCode='';
                woInESN.Before_In_Service__c = true;
                filterMake='';
            } else {


                string sQSOLConn;
                if(!Test.isRunningTest()){
                    sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;
                }
                else{
                    sQSOLConn = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                }
                //lDocType = new List<STRING>{'CAM','TRP','TSB'};

                //Get Dataplate information from QSOL based on ESN
                /*CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
                rDataPlate = wsCall.getEngineDataplate(sQSOLConn, ESN);*/
                rDataPlate = CG_BL_Intake.GetEngineDataPlateQSOL(ESN); //GSSC_97, ROD:Qsol changes
                system.debug('rDataPlate>>>'+rDataPlate);
                //Calling SiebelWS to get data 63173-Start

                CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
                
                CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
                jidi.ESN=ESN;
                wrapobj.DataArea = jidi;
                engineData = CSS_WS_SBL.getEngineData(wrapobj);
                /*Story#183077*/
                //if((rDataPlate!=null && rDataPlate.ResponseMessage!=null && rDataPlate.ResponseMessage.contains('SUCCESS')) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
               /* if((rDataPlate!=null) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
                { 
                    // psnsererrflag=false;
                    maincontroller.PSNFlagtnd=false;//story#183077
                }
                else{

                    // psnsererrflag=true;
                    maincontroller.PSNFlagtnd=true;//story#183077
                    CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                    intEngError.Processed_Data__c =  String.valueof(wrapobj);
                    intEngError.Response_Body__c = 'Access Denied';
                    intEngError.Service_Job_Number__c = maincontroller.workJob.Name;
                    intEngError.Service_Name__c = 'GetEngineDataService';
                    intEngError.Source__c = 'SIEBEL';
                    //intEngError.WWID__c = FedId; 

                    insert intEngError;
                }*/
                 //ROD Changes GSSC_97, As per latest update, QSOL Service call is stopped and data is retrieved from Asset
            if( (rDataPlate == null || rDataPlate.DataArea == null) &&  (engineData == null || engineData.DataArea == null || !engineData.Header.Status.contains('Success')))
            {
                maincontroller.PSNFlagtnd=true;
                CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                intEngError.Processed_Data__c =   String.valueof(wrapobj);
                intEngError.Response_Body__c = 'Access Denied';
                intEngError.Service_Job_Number__c = maincontroller.workJob.Name;
                intEngError.Service_Name__c = 'GetEngineDataService';
                intEngError.Source__c = 'SIEBEL';
                //intEngError.WWID__c = FedId; 
                
                insert intEngError;
                
            }
            else{
                        maincontroller.PSNFlag=false;
                    }

                /*end*/
                // system.debug('psnsererrflag>>>>'+psnsererrflag);
                system.debug('engineData>>>>'+engineData);
                  system.debug('engineData>>>>'+engineData);
                if (engineData.DataArea != null && engineData.Header.Status.contains('Success')){

                    if ( string.valueOf(engineData.DataArea.ProdAppDesc)!='' )
                        siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.ProdAppDesc),null,null);
                    if( siebAppCode !='' || siebAppCode!=null){
                        system.debug('siebelApp'+string.valueOf(engineData.DataArea.ProdAppDesc));
                        woInESN.Application__c= engineData.DataArea.ProdAppDesc;
                        woInESN.Application_Desc__c = engineData.DataArea.ProdAppDesc;
                        woInESN.ApplicationCode__c = engineData.DataArea.EngineAppCode;
                    }
                      system.debug(' woInESN.ApplicationCode__c >>>>'+ woInESN.ApplicationCode__c );
                    if ( string.valueOf(engineData.DataArea.NoWarranty)!=''  )
                    woInESN.warrantyIndicatorFlag__c = (engineData.DataArea.NoWarranty == 'Y' ? 'N' : 'Y'); // Story 124

                    if ( string.valueOf(engineData.DataArea.ServiceModelName)!=''  )
                        siebelSMN= engineData.DataArea.ServiceModelName;

                    if (string.valueOf(engineData.DataArea.WarrantyStartDate)!='')               
                        siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));

                    if ( string.valueOf(engineData.DataArea.Manufacturer)!=''){
                        filterMake= engineData.DataArea.Manufacturer;
                        //Chking if Make exists in CSS
                        filterMake = css_utility.getMake(filterMake);
                    }

                    if (string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){
                        filterModel= engineData.DataArea.Model;
                        //chking if Model exists
                        filterModel = css_utility.getModel(filterMake,filterModel);
                    }

                    if (string.valueOf(engineData.DataArea.vin)!='' && string.valueOf(engineData.DataArea.vin) !='' ){
                        siebVIN = string.valueOf(engineData.DataArea.vin);
                    }

                    woInESN.PSN_PACCAR_Flag__c = engineData.DataArea.PACCARFlag;
                    woInESN.Qsol_Engine_Family_Code__c = engineData.DataArea.EngineFamilyCode;
                    woInESN.EngineFamilyCode__c = engineData.DataArea.EngineFamilyCode;
                    woInESN.Equipment_ID__c = string.valueOf(engineData.DataArea.EquipmentId);
                    rJobOrd.EngineFamilyCode__c = engineData.DataArea.EngineFamilyCode;
                    rJobOrd.Equipment_ID__c = string.valueOf(engineData.DataArea.EquipmentId);

                }
 if(woInESN.ApplicationCode__c == '130' || woInESN.ApplicationCode__c == '210' || woInESN.ApplicationCode__c == '220' || woInESN.ApplicationCode__c == '310' || woInESN.ApplicationCode__c =='320' || woInESN.ApplicationCode__c =='410')
                    woInESN.Automotive_App_Flag__c = 'Y';
                else
                    woInESN.Automotive_App_Flag__c = 'N';
                system.debug(' woInESN.Automotive_App_Flag__c'+ woInESN.Automotive_App_Flag__c);
               
                //Calling SiebelWS to get data 63173-End
                if(rDataPlate != null && rDataPlate.DataArea != null)
                    sServiceModel = rDataPlate.DataArea.ServiceModelName;

                if ((sServiceModel =='' || sServiceModel==null) && (siebelSMN!='' && siebelSMN!= null)){                    
                    sServiceModel = siebelSMN;
                }
                rJobOrd.Service_Model__c = sServiceModel;
                woInESN.Service_Model__c = sServiceModel;
                system.debug('SMN'+siebelSMN+''+rJobOrd.Service_Model__c);

                system.debug('data is '+siebelSMN+''+siebAppCode+''+siebelWarrantyDate+''+filterMake+''+filterModel);

                if(rDataPlate != null && rDataPlate.DataArea.EngineFamilyCode != null){
                    sEngineFamilyCode = rDataPlate.DataArea.EngineFamilyCode;
                    woInESN.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                }
                System.debug('QSOL retrived EngineFamilyCode in Intake>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+sEngineFamilyCode);
                if(rDataPlate != null && rDataPlate.DataArea != null && (rDataPlate.DataArea.vin!= '' || rDataPlate.DataArea.vin!=null)){
                    woInESN.VIN__c = rDataPlate.DataArea.vin;
                    woInESN.VIN_Flag__c = false;
                }
                if((woInESN.VIN__c == '' || woInESN.VIN__c == null) && ( siebVIN!='' || siebVIN != null)){
                    woInESN.VIN__c = siebVIN; 
                    woInESN.VIN_Flag__c = false;
                }
                if((woInESN.VIN__c == '' || woInESN.VIN__c == null) && ( siebVIN == '' || siebVIN == null))
                {
                    woInESN.VIN_Flag__c = true;
                    woInESN.VIN__c = '';
                }
                if ( filterMake !='' && filterMake != null){
                    woInESN.Make__c = filterMake;                  
                }
                else{
                    woInESN.Make__c = '';
                }
                if ( filterModel != '' && filterModel!= null){
                    woInESN.Model__c=filterModel;
                }
                else{
                    woInESN.Model__c='';
                }

                System.debug('sServiceModel: '+sServiceModel);

                if(sServiceModel != null && sServiceModel != ''){
                    Set<String> hhpSet = new Set<String>();
                    for(CSS_Listof_HHP_SMNS__c hhp: CSS_Listof_HHP_SMNS__c.getAll().Values()){
                        hhpSet.add(hhp.Listof_HHP_SMN__c);
                    }
                    //Id userId = UserInfo.getUserId();
                    //User user = [select Product_Group_Access__c from user where Id = :userId];
                    String PGA = (String)Cache.Session.get('local.CSSPartition.UserEDSPorductGroupAccess');
                    if(hhpSet.contains(sServiceModel)){
                        HHSPSMNFlg=true;
                        // Moved to the end of method >> add to Audit trial  : ‘Engine Identified as a Cummins High HorsePower Engine’
                        //css_functionality.addToJobHistory('CSS_Job_Order__c',rJobOrd.Id,'Status__c','','Engine Identified as a Cummins High HorsePower Engine');
                        if('PGA01'.endsWithIgnoreCase(PGA)){
                            HHSPACCSFlg=true;
                            // Moved to the end of method >> add to Audit trial : ‘User is certified to work on HHP Engine’
                            //css_functionality.addToJobHistory('CSS_Job_Order__c',rJobOrd.Id,'Status__c','','User is certified to work on HHP Engine');
                        }else{
                            system.debug('Anirudh'+'Entered into No HHP Access Flag ');
                            HHSPACCSFlg=false;
                            if(HHPPopUp == 'CloseJob')
                                displayHHPPopup1=true;
                            else if(HHPPopUp == 'UseCSSEsn'){
                                displayINPop = false;
                                displayHHPPopup2=true;
                            }
                        }
                    }else{
                        HHSPSMNFlg=false;
                    }
                }else{
                    displaySrvModPopup=true;
                    displayINPop = false;
                }
                map<String,String> accCerts = CG_BL_Intake.getCertificationStatus(rJobOrd.Service_Model__c,rJobOrd.Failure_Date__c,rJobOrd.Account__c,rJobOrd.Account__r.Warranty_Training_Certification__c,rJobOrd.Account__r.Product_Certification__c, rJobOrd.Account__r.Warranty_Training_Status__c, rJobOrd.Account__r.CERTIFICATION_END_DATE__c);
                if(accCerts.containsKey('warrCertFlag')){                       
                    woInESN.Location_Certification__c=accCerts.get('certStatus');
                    woInESN.Warranty_Authorization_Flag__c=accCerts.get('warrCertFlag');
                } 
                system.debug('JobData--'+JobData);
                spdatastatus= CG_BL_Intake.fetchSPData(JobData,JobData.creator_location__c, null, JobData.Failure_Date__c, JobData.id).SPDataWebserviceResult__c;
                woInESN.SPDataWebserviceResult__c=spdatastatus;
 

            }
        }
        catch(exception e){
            system.debug('inside catch'+e.getMessage()+' '+e.getLineNumber());
            /*Story#183077*/
            //if((rDataPlate!=null && rDataPlate.ResponseMessage!=null && rDataPlate.ResponseMessage.contains('SUCCESS')) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
            if((rDataPlate!=null) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
            { 
                // psnsererrflag=false;
                maincontroller.PSNFlagtnd=false;//story#183077
            }
            else{
                // psnsererrflag=true;
                maincontroller.PSNFlagtnd=true;//story#183077
            }

            /*end*/
            woInESN.Service_Model__c = '';
            woInESN.VIN__c = '';
            woInESN.Warranty_Start_Date__c =null;
            woInESN.Location_Certification__c='';
        }
    }
    /******** END Start Request Method*** **********/

    /******** ADD HHP ESNs to Audit Trail *******/
    public void addHHPEsnToAuditTrail(){
        try{
            if (HHSPSMNFlg == true){
                system.debug('calling HHSPSMNFlg=true');
                css_functionality.addToJobHistory('CSS_Job_Order__c',rJobOrd.Id,'Status__c','','Engine Identified as a Cummins High HorsePower Engine');
            }
            if (HHSPACCSFlg == true){
                system.debug('calling HHSPSMNFlg=true');
                css_functionality.addToJobHistory('CSS_Job_Order__c',rJobOrd.Id,'Status__c','','User is certified to work on HHP Engine');                    
            }
        }catch(exception e){}
    }
    /******* End HHP ESNs to Audit Trail *******/

    /*******Method*** to Close Wrong ESN Popup *****/
    public void closeSrvModPopup(){
        displaySrvModPopup = false;
    }
    /*******End Method*** to Close Wrong ESN Popup*****/

    /******Method*** To Close the Job *******/
    public PageReference pgSaveFinish()
    {
        try{
            //  css_dsidclose dscls = new css_dsidclose();
            System.Debug('in pgSaveFinish==============');
            css_job_order__c worecord= new css_job_order__c();
            worecord.Previous_Status__c = rJobOrd.Status__c; 
            worecord.Status__c='Closed';

            if (HHSPSMNFlg && !HHSPACCSFlg)
            {
                // log into Audit trial - ‘User is NOT certified to work on HHP Engine, job has been closed’            
                css_functionality.addToJobHistory('CSS_Job_Order__c',rJobOrd.Id,'Status__c','','User is NOT certified to work on HHP Engine, job has been closed');
            }
            worecord.id=rJobOrd.id;
            if(rJobOrd.Warranty_Start_Date__c != null){     
                worecord.Before_In_Service__c = false;      
            }else{worecord.Before_In_Service__c = true;}
            update worecord;
            System.Debug('record updated====='+worecord);
        }catch(exception e){}
        //}
        PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        pageRef.setRedirect(true);
        return pageRef;

    }
    /****** End Method*** to Close the Job ****/


}