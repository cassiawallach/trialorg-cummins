/**********************************************************************
Name:CG_CL_ClaimsCampaignsTRPsATCs
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used for Claims Campaigns functionalities
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M         03/19/2018      INITIAL DEVELOPMENT & implementation of Campaigns functionality 
1.1Kalpana V          23/03/20118     Account Code - Pay Code List Implementation
***********************************************************************/
public class CG_CL_ClaimsCampaignsTRPsATCs 
{

    public boolean noclvalueerror{get;set;}//For error message display 
    public boolean noclvalueborder{get;set;}//For red error border display
    public Id Wid {get;set;}
    public List<SelectOption> cltype{get;set;}//CSS_Solution_Component__c also has a field type Claim_Type__c

    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public List<CSS_Solution_Component__c> solCompCampTRP = new List<CSS_Solution_Component__c>();
    public List<CSS_Solution_Component__c> lstExistingFailures = new List<CSS_Solution_Component__c>();
    // public List<CSS_Solution_Component__c> solCompCampTRP1 = new List<CSS_Solution_Component__c>();
    public List<CSS_CampTsbTrp__c> CTAList = new List<CSS_CampTsbTrp__c>();
    //public list<CSS_Solution_Component__c> ListUpdateSolCompCampTRP{get;set;}
    public CG_CL_ClaimsFC mainContr{set; get;}
    public CSS_Job_Order__c bmsUser{get;set;}//Added by Agassi
    public String SelClaimtype{get;set;}//Selected Claim
    public list<SolCompWrapper> listSolcompWrapper {get;set;}
    public boolean checkmultipsn{get;set;} //Added by Gopal for story 153560
    public Boolean isDealer {get;set;}
    public Boolean solCompListOne {get;set;}
    public String errormsg{get;set;}//errormsg
    public boolean showCampaignPopup{get;set;}
    //public boolean multiCamATCExist{get;set;}
    public Map<String, Boolean> savedSelectedCamATCMap{get;set;}
    public Map<String, Boolean> existingSelection{get;set;}
    public boolean showFieldActionPaccar{get;set;} 
    //Constructor.
    public CG_CL_ClaimsCampaignsTRPsATCs()
    {
        savedSelectedCamATCMap = new Map<String, Boolean>();
        noclvalueerror=false;
        noclvalueborder=false;
        checkmultipsn = false;
        errormsg=null;
        System.debug('IN CG_CL_ClaimsCampaignsTRPsATCs constructor...');
        try { 
            Id cId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('mainContr11>>>>:'+mainContr);
            if(cId != null) {
                claimsRec =[Select Id,No_Failure_PACCAR_Flag__c,Parts_Warranty_Claim_Only__c,PACCAR_PW_AutoSelected__c,PACCAR_Auth_Required__c, PACCAR_Flag__c,CSS_PACCAR_Auth_Track__c,Catastrophic__c,Account__r.Type,Account__r.isCampTrp__c,FieldActionWebServiceResult__c,IsDealerCreatedClaim__c,CSS_Job__c,Account__r.region__c,Account__r.Territory__c,Account__r.ERP_System__c,Name,Multi_PSN_Claim__c, 
                            (Select Id,Name,CoverageFlag__c,PSN__c,Before_In_Service__c,Failure_Date__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                            from CSS_Claims__c where id= :cId]; 
                
                if((claimsRec.No_Failure_PACCAR_Flag__c == true && claimsRec.Parts_Warranty_Claim_Only__c == true) || claimsRec.PACCAR_PW_AutoSelected__c == true || (claimsRec.IsDealerCreatedClaim__c && claimsRec.Parts_Warranty_Claim_Only__c && claimsRec.PACCAR_Flag__c && !claimsRec.CSS_PACCAR_Auth_Track__c)) {
                	showFieldActionPaccar = false; 
                  } 
                  else{
                      showFieldActionPaccar = true;
                  } 
                
                if(claimsRec.Multi_PSN_Claim__c == true && claimsRec.CSS_Job__c==null){
                    checkmultipsn=true;
                }
                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);

                }


                getCampTRPATCs();

                isDealer = true;
                string userType = css_Utility.getOrgType(userinfo.getUserId());
                if(userType!=null && userType!= '') {
                    if(userType == 'DLR') {
                        isDealer = true;
                    }else if(userType == 'DISTR') {
                        isDealer = false;
                    }
                }
            }                


        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsCampaignsTRPsATCs constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsCampaignsTRPsATCs constructor...'); 
    }

    //To fetch claim type
    public List<SelectOption> getfetchclaimtypes()
    {
        String CreatorLocation; 
        cltype = new List<SelectOption>();
        CreatorLocation = [select Location_code__c from css_claims__c where id = :claimsRec.id].Location_code__c;
        //It should be claimsRec.id instead of wid: (Kalpana)
        //03520-04892 location has data valueo
        //cltype=CG_BL_Claims.getClaimType(claimsRec.id,'03520-04892','ClaimsFC');
        cltype=CG_BL_Claims.getClaimType(Wid,CreatorLocation,'ClaimsFC');//TO uncode
        system.debug('Location Code Fetched from the User:'+CreatorLocation); 
        return cltype;
    }

    public PageReference campaignPopupshow(){
        showCampaignPopup = false;
        system.debug('Save button Clicked claimsRec.'+claimsRec);
        system.debug('Save savedSelectedCamATCMap .'+savedSelectedCamATCMap);
        system.debug('existingSelection -->'+existingSelection);
        // if(claimsRec !=null && claimsRec.Multi_PSN_Claim__c==true && savedSelectedCamATCMap !=null && savedSelectedCamATCMap.size()>0){
        if(claimsRec !=null){ //&& savedSelectedCamATCMap !=null && savedSelectedCamATCMap.size()>0){ //Commented above line as per story 179356
            //if exist records are already saved & selected then if unchecked
            for(SolCompWrapper fcw : listSolcompWrapper){
                system.debug('fcw.SelectedComp--->'+fcw.SelectedComp);
                Boolean temp = existingSelection.get(fcw.FieldActNum);
                if(fcw.SelectedComp == false && temp == true && showCampaignPopup == false){
                    showCampaignPopup = true;
                    break;
                }
            }
            system.debug('showCampaignPopup-->'+showCampaignPopup);
            if(showCampaignPopup)
                return null;
            else{
                //Commented below line as part of the defect # 191553
                //UpdateSolComWithClaimType();
                //START - As part of the defect # 191553
                PageReference pageRefNew = UpdateSolComWithClaimType();
                system.debug('pageRefNew-->'+pageRefNew);
                if(pageRefNew != null){
                    system.debug('inside if condition');
                    pageRefNew.setRedirect(true);
                    return pageRefNew;
                }
                //END - As part of the defect # 191553
            }
        }
        
        //PageReference  pageRef = new pageReference('/apex/CG_ClaimsFC?id='+claimsRec.id);
        //pageRef.setRedirect(true);
        return null;
    }
    //To Update the selected claim type
    public PageReference UpdateSolComWithClaimType()
    {
        system.debug('Save button Clicked.');
        //save method
        //Prabhar's Changes
        showCampaignPopup = false;
        errormsg = '';
        try
        {
            // campaignPopupshow();
            //code for delte camATCPopup
            system.debug('Save button Clicked claimsRec.'+claimsRec);
            system.debug('Save claimsRec.Multi_PSN_Claim__c.'+claimsRec.Multi_PSN_Claim__c);
            system.debug('Save savedSelectedCamATCMap .'+savedSelectedCamATCMap);
            system.debug('savedSelectedCamATCMap.size().'+savedSelectedCamATCMap.size());
            /*if(claimsRec !=null && claimsRec.Multi_PSN_Claim__c==true && savedSelectedCamATCMap !=null && savedSelectedCamATCMap.size()>0){
                //if exist records are already saved & selected then if unchecked
                //here need to logic
                //here need to take one map which should contain all saved & selected solComps in Db
                //then check that map with fcw.FieldActNum
                for(SolCompWrapper fcw : listSolcompWrapper){
                    system.debug('fcw.SelectedComp--->'+fcw.SelectedComp);
                    if(fcw.SelectedComp == false){
                        system.debug('inside if fcw.SelectedComp.'+fcw.SelectedComp);
                        system.debug('inside if fcw.FieldActNum.'+fcw.FieldActNum);
                        if(savedSelectedCamATCMap.containsKey(fcw.FieldActNum)){
                            system.debug('inside map if ');
                            showCampaignPopup = true;
                            break;
                        }
                    }
                }
                if(showCampaignPopup)
                    return null;
            }*/
            //End


            integer seletedCompCount = 0;
            lstExistingFailures = [select Id, Selected_Component__c from CSS_Solution_Component__c where Type__c not in ('Campaign','TRP','ATC','TSB') and CSS_Claims__c =:claimsRec.id and Selected_Component__c = true];
            if(lstExistingFailures.size()>0)
            {
                solCompListOne = true;
                //mainContr.showError1 = true;
            }else
            {
                //mainContr.showError1 = false;
                solCompListOne = false;
            }

            system.debug('lstExistingFailures**'+lstExistingFailures.size());
            noclvalueerror = false;
            Set<String> FieldActNumSet = new Set<String>(); // Added as per story 179356
            Set<String> UnSelFieldActNumSet = new Set<String>(); //Declared the variable as part of the defect #189704
            List<CSS_Solution_Component__c> lstSolCompToBeUpdated = new List<CSS_Solution_Component__c>();
            Boolean needCampaignCallout = false;
            system.debug('existingSelection'+existingSelection);
            if(listSolcompWrapper != null && listSolcompWrapper.size()>0){
                for(SolCompWrapper fcw : listSolcompWrapper){
                    Boolean temp = existingSelection.get(fcw.FieldActNum);
                    if(fcw.SelectedComp == true && temp == false){
                        if(needCampaignCallout == false){
                            needCampaignCallout = true;
                        }
                        FieldActNumSet.add(fcw.FieldActNum);
                    }
                    //Added below if condition as part of the defect #189704
                    if(fcw.SelectedComp == false && temp == true){
                        UnSelFieldActNumSet.add(fcw.FieldActNum); 
                    }
                    if(fcw.SelectedComp == true){
                        seletedCompCount = seletedCompCount +1;
                        //FieldActNumSet.add(fcw.FieldActNum);// Added as per story 179356
                    }
                    system.debug('seletedCompCount**'+seletedCompCount);
                    CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
                    solComp.Id = fcw.SolCompId;//To update the solution component you need the ID..
                    //solComp.Selected_Component__c = fcw.SelectedComp;
                    solComp.Selected_Claim_Type__c = fcw.Selectedclaimtype;
                    solComp.Selected_Component__c = fcw.SelectedComp;
                    if(fcw.SelectedPayCode != 'Select One' && fcw.SelectedPayCode != '' && fcw.SelectedPayCode != null){//Added not equal to select one as part of GSSC-247.
                    solComp.Pay_Code__c = fcw.SelectedPayCode;
                    }
                    /*if((fcw.Selectedclaimtype=='Select One' || fcw.Selectedclaimtype==''|| fcw.Selectedclaimtype==null) && isDealer == false)
                    {
                        noclvalueerror=true;//This value to be true if select one  
                        noclvalueborder=true;//This value to be true if select one 

                        System.debug('There is no value for selected claim');
                    }*/
                    System.debug('***showCampaignPopup****'+showCampaignPopup);
                    System.debug('***fcw.SelectedComp****'+fcw.SelectedComp);
                    System.debug('***claimsRec.CSS_PSNs__r.size()>1****'+claimsRec.CSS_PSNs__r.size());
                    /*if(fcw.SelectedComp == false && claimsRec.CSS_PSNs__r.size()>0 && lstExistingFailures.size()==0){
                        System.debug('***Inside if showCampaignPopup****');
                        showCampaignPopup=true;
                        System.debug('***showCampaignPopup****'+showCampaignPopup);
                    }*/

                    //if(claimsRec.Multi_PSN_Claim__c == true && (lstExistingFailures.size()>0 || seletedCompCount >1)){
                    if(claimsRec.Multi_PSN_Claim__c == true && (lstExistingFailures.size()>0 || seletedCompCount >1)){
                        system.debug('Do Not Save**');
                        system.debug('lstExistingFailures**'+lstExistingFailures.size());
                        system.debug('seletedCompCount**'+seletedCompCount);
                        //if(lstExistingFailures.size()>0 && seletedCompCount <=1)
                        if(lstExistingFailures.size()>0 && seletedCompCount >=1)
                            errormsg =  Label.CG_Only_Failures_or_one_Campaign_ATC_is_allowed_on_Multi_PSN_claim;
                        else if(lstExistingFailures.size()==0 && seletedCompCount >1)
                            errormsg =  Label.CG_Only_one_Campaign_or_one_ATC_is_allowed_on_a_Multi_PSN_Claim;
                        /*else if(lstExistingFailures.size()>0 && seletedCompCount >1)
                            errormsg =  Label.CG_Only_Failures_or_one_Campaign_ATC_is_allowed_on_Multi_PSN_claim;*/
                        system.debug('errormsg**'+errormsg);
                        if(errormsg!=null && errormsg!='')
                            return null;
                    }
                    if(errormsg == '' || errormsg==null){
                        lstSolCompToBeUpdated.add(solComp);
                    }
                }

                // Added below Service Call as per story 179356, to insert Field Action Parts on re-selectionof Field Action
                CG_OP_OAGWrapper ReselectResp = new CG_OP_OAGWrapper();
                if(FieldActNumSet != null && FieldActNumSet.size()>0){
                    String FailureDateString = DateTime.newInstance(PsnRec.Failure_Date__c.year(),PsnRec.Failure_Date__c.month(),PsnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                    //   CG_OP_OAGWrapper ReselectResp = new CG_OP_OAGWrapper();
                    system.debug('needCampaignCallout'+needCampaignCallout);
                    if(needCampaignCallout == true){
                        //Added additional parameter in below line as part of the defect #189704
                        ReselectResp = CG_BL_Campaigns.callGetCampaignsWSforClaimsonReselect(psnRec.psn__c, FailureDateString,'','', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty',claimsRec.id,FieldActNumSet, UnSelFieldActNumSet);
                    }
                }

                /*if( ReselectResp == null){
                   claimsRec.FieldActionWebServiceResult__c = 'Error';
               }
               else
               {
                   claimsRec.FieldActionWebServiceResult__c = 'Success';
               }*/

                //Moved update code below, as the service call above for 179356
                if(lstSolCompToBeUpdated != null && lstSolCompToBeUpdated.size()>0)
                {

                    update lstSolCompToBeUpdated;
                }
                existingSelection = new Map<String, Boolean>();
                if(claimsRec !=null && claimsRec.Multi_PSN_Claim__c == false){
                    solCompCampTRP = [select Selected_Claim_Type__c,Type__C,css_claims__r.Information_Only_Claim__c, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c 
                                      from CSS_Solution_Component__c where Type__c in ('Campaign','TRP','ATC') and CSS_Claims__c =:claimsRec.id  and Status__c='Approved'];
                }else{
                    solCompCampTRP = [select Selected_Claim_Type__c,Type__C,css_claims__r.Information_Only_Claim__c, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c 
                                      from CSS_Solution_Component__c where Type__c in ('Campaign','ATC') and CSS_Claims__c =:claimsRec.id  and Status__c='Approved'];
                }
                for(css_solution_component__c SolComp1: SolCompCampTRP){
                    existingSelection.put(SolComp1.Component_Id__c, SolComp1.Selected_Component__c);
                }
                //To refresh if it is Multi PSN
                if(checkmultipsn){
                    PageReference pageRef = new PageReference('/apex/CG_ClaimsFC?id='+claimsRec.id);
                    //pageRef.setRedirect(true); //Commented this line as part of the defect # 191553
                    return pageRef;
                }else
                    return null;

            }
        }catch(Exception e)  
        {
            system.debug('EXCEPTION of saveClaimData method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        } 
        return null;
    }

    //function to delete the Campaign and ATC Record
    Map<String,String> failAccCodeMap;
    public PageReference deleteCamATCRecord(){
        system.debug('inside Delete method'+claimsRec.id);
        //kalpana 179356
        failAccCodeMap = new Map<string,string>();
        Set<String> nonSelFieldAction = new Set<String>();
        if(claimsRec !=null){
            for(SolCompWrapper fcw : listSolcompWrapper){
                system.debug('fcw.SelectedComp--->'+fcw.SelectedComp);
                if(fcw.SelectedComp == false){
                    system.debug('inside if fcw.SelectedComp.'+fcw.SelectedComp);
                    system.debug('inside if fcw.FieldActNum.'+fcw.FieldActNum);
                    failAccCodeMap.put(fcw.FailCode,fcw.AccountCode);
                    nonSelFieldAction.add(fcw.SolCompId);
                }
            }
        }
        system.debug('failAccCodeMap**'+failAccCodeMap);
        system.debug('nonSelFieldAction**'+nonSelFieldAction);
        //query for associated SRTs
        List<css_srt__c> srtList = [Select id,Component_Id__c,FailCode__c, AccountCode_Formula__c from css_Srt__c where css_claims__c = :claimsRec.id AND 
                                    (Type__c IN ('Admin','Field Action','Field Action Access','CAMPAIGN','TRP','ATC','99Time') OR SRT_Category__c IN ('CAMPAIGN','TRP','ATC'))];
        system.debug('srtList**'+srtList);
        String[] Codes;
        String FailAccode = '';
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
                if(nonSelFieldAction.contains(srt.Component_Id__c)){
                    deletesrtList.add(srt);
                }
            }
        }
        system.debug('deletesrtList'+deletesrtList);
        //query for associated Parts
        List<CSS_Parts_Options__c> partsList = [select id,Fail_Code__c,FailurepartId__c,Get_Fail_Code_Formula__c,Account_Code__c,recordtype.name,Parts_Type__c from CSS_Parts_Options__c
                                                where css_Claims__c = :claimsRec.id AND ((recordtype.name = 'Parts' AND parts_type__c = 'Custom') OR (recordtype.name = 'Parts' AND FailurepartId__r.type__c IN ('CAMPAIGN','TRP','ATC')) OR recordtype.name IN('OtherClaimables','TTML'))];
        system.debug('partsList**'+partsList);
        List<CSS_Parts_Options__c> deletepartsList = new List<CSS_Parts_Options__c>();
        for(CSS_Parts_Options__c part: partsList){
            system.debug('Inside ELSE**'+part.Get_Fail_Code_Formula__c);
            system.debug('Inside ELSE1**'+part.Account_Code__c);
            if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c != null && part.Account_Code__c != '') && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) == part.Account_Code__c ){
                system.debug('Inside SET**');
                deletepartsList.add(part);
            }
            else if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c == null || part.Account_Code__c == '') && (failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != null && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != '') )
                deletepartsList.add(part);
        }
        system.debug('deletepartsList'+deletepartsList);

        UpdateSolComWithClaimType();
        if(deletesrtList != null && deletesrtList.size()>0)
            delete deletesrtList;
        if(deletepartsList != null && deletepartsList.size()>0)
            delete deletepartsList;

        if(claimsRec.id!=null&& claimsRec.Multi_PSN_Claim__c==true){
            try{ 
                List<CSS_PSN__c> psnList = new List<CSS_PSN__c>([select Id, Name, CSS_Claims__c, Warranty_Start_Date__c, Primary__c, Before_In_Service__c, PSN__c 
                                                                 from  CSS_PSN__c where CSS_Claims__c=: claimsRec.id AND Primary__c=false]);
                system.debug('psnList888888'+psnList);
                system.debug('psnList.size()888888'+psnList.size());

                if(psnList != null && psnList.size() > 0)
                    delete psnList;
            }
            catch(Exception e){
                System.debug('exception in DeleteSolRecord function'+e.getMessage() + ' ' + e.getLineNumber());
            }
        }
        PageReference  pageRef = new pageReference('/apex/CG_ClaimsFC?id='+claimsRec.id);
        pageRef.setRedirect(true);
        return pageRef;
    }


    public List<String> LstAccCodes = new List<string>();
    public Map<string,String> MapAccCode = new Map<string,String>();
    public list<string> lstpaycode {get;set;}
    public String Reason1;
    public List<SelectOption> lstPaycodeValues;

    public void getCampTRPATCs(){
        try{
            solCompCampTRP = new List<CSS_Solution_Component__c>();
            CTAList = new List<CSS_CampTsbTrp__c>();
            existingSelection = new Map<String, Boolean>();
            if(claimsRec !=null && claimsRec.Multi_PSN_Claim__c == false){
                solCompCampTRP = [select Selected_Claim_Type__c,Type__C,css_claims__r.Information_Only_Claim__c, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c 
                                  from CSS_Solution_Component__c where Type__c in ('Campaign','TRP','ATC') and CSS_Claims__c =:claimsRec.id  and Status__c='Approved'];
            }else{
                solCompCampTRP = [select Selected_Claim_Type__c,Type__C,css_claims__r.Information_Only_Claim__c, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c 
                                  from CSS_Solution_Component__c where Type__c in ('Campaign','ATC') and CSS_Claims__c =:claimsRec.id  and Status__c='Approved'];
            }

            System.debug('solCompCampTRP>>:'+solCompCampTRP+' solCompCampTRP size>>:'+solCompCampTRP.size()+' solCompCampTRP>>>>:'+solCompCampTRP);
            CTAList = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where CSS_Claims__c= :claimsRec.id AND ESN__c = :psnRec.PSN__c  AND Type__c !='TSB'
                       order by Performed_Review__c desc LIMIT 1000];
            System.debug('CTAList size>>:'+CTAList.size()+' CTAList>>>>:'+CTAList);

            lstPaycodeValues = new List<SelectOption>();
            listSolcompWrapper = new List<SolcompWrapper>();
            system.debug('SolCompCampTRP***'+SolCompCampTRP);
            system.debug('CTAList***'+CTAList);

            for(css_solution_component__c SolComp1: SolCompCampTRP){
                if(SolComp1.AccountCodeEdit__c != '' && SolComp1.AccountCodeEdit__c != null){
                    system.debug('**'+SolComp1.AccountCodeEdit__c);
                    LstAccCodes.add(SolComp1.AccountCodeEdit__c.right(2).trim());
                    system.debug('AccountCodeType__c**'+SolComp1.AccountCodeType__c);
                    system.debug('AccountCodeEdit__c**'+SolComp1.AccountCodeEdit__c.right(2));
                    system.debug('AccountCode__c**'+SolComp1.AccountCode__c);
                }
                // if(claimsRec !=null && claimsRec.Multi_PSN_Claim__c==true && SolComp1.Selected_Component__c==true){ // Commented as per story 179356
                if(claimsRec !=null && SolComp1.Selected_Component__c==true){
                    //multiCamATCExist=true;
                    savedSelectedCamATCMap.put(SolComp1.Component_Id__c,true);
                }
                existingSelection.put(SolComp1.Component_Id__c, SolComp1.Selected_Component__c);
            }
            system.debug('ListofAccountCodes**'+LstAccCodes);
            List<CSS_JobEventTemporary__c> payCodeJETList = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c IN :LstAccCodes];
            system.debug('Reason**'+payCodeJETList);         
            for(CSS_JobEventTemporary__c jet: payCodeJETList){
                if(jet.Reason__c !=null){
                    MapAccCode.put(jet.Attribute3__c,jet.Reason__c);}
            }
            system.debug('MapAccCode**'+MapAccCode); 

            //if((SolCompCampTRP != null && SolCompCampTRP.size()>0) && (CTAList != null || CTAList.size()>0)){
            if(SolCompCampTRP != null && SolCompCampTRP.size()>0){
                system.debug('entered...CTAList.size>>>:'+CTAList.size());
                for(css_solution_component__c SolComp: solCompCampTRP)
                {
                    lstPaycodeValues = new List<SelectOption>();
                    if(SolComp.AccountCodeEdit__c != '' && SolComp.AccountCodeEdit__c != null){
                        if(SolComp.css_claims__r.Information_Only_Claim__c) //Added logic for Information Only Claims
                        {
                            list<string> sh = new list<string>{'A'};
                            lstPaycodeValues= getPayCodes(sh);
                        }
                        else{
                            lstPaycodeValues = getPayCodesList(SolComp.AccountCodeEdit__c.right(2).trim());
                        }
                    }
                    if(CTAList != null && CTAList.size()>0){
                        for(CSS_CampTsbTrp__c campRec : CTAList){
                            system.debug('**Inside Second For Loop **');

                            // if(SolComp.Component_Id__c == campRec.Doc_Num__c)campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length())
                            if(solComp.Component_Id__c !=null && solComp.Component_Id__c.trim() !='' && campRec.Doc_Num__c !=null && campRec.Doc_Num__c.trim() !=''){
                                if(solComp.Type__c == 'CAMPAIGN'){
                                    if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) && campRec.Type__c == 'CAM'){
                                        solComp.URL__c = campRec.URL__c;
                                        break;
                                    }
                                }else if(solComp.Type__c == 'TRP'){
                                    if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) && campRec.Type__c == 'TRP'){
                                        solComp.URL__c = campRec.URL__c;
                                        break;
                                    }
                                }else if(solComp.Type__c == 'ATC'){
                                    if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(3,campRec.Doc_Num__c.length()) && campRec.Type__c == 'ATC'){
                                        solComp.URL__c = campRec.URL__c;
                                        break;
                                    }
                                }

                            }
                        }
                    }
                    system.debug('SolComp.id**'+SolComp.id);
                    system.debug('SolComp.Selected_Component__c**'+SolComp.Selected_Component__c);
                    system.debug('SolComp.Type__c**'+SolComp.Type__c);
                    system.debug('SolComp.Campaign_Description__c**'+SolComp.Campaign_Description__c);
                    system.debug('SolComp.Component_id__c**'+SolComp.Component_id__c);
                    system.debug('SolComp.Fail_Code__c**'+SolComp.Fail_Code__c);
                    system.debug('SolComp**'+SolComp.AccountCodeEdit__C);
                    system.debug('lstpaycode**'+lstpaycode);

                    listSolcompWrapper.add(new SolCompWrapper(SolComp.id,SolComp.Selected_Component__c,SolComp.URL__c,
                                                              SolComp.Type__c+'-'+SolComp.Campaign_Description__c,
                                                              SolComp.Component_id__c,SolComp.Fail_Code__c,
                                                              Solcomp.AccountCodeEdit__C,SolComp.pay_code__c,lstPaycodeValues,Solcomp.Selected_Claim_Type__c,cltype));

                    system.debug('SolComp**'+SolComp);
                    system.debug('listSolcompWrapper**'+listSolcompWrapper);


                    //  ListUpdateSolCompCampTRP.add(SolComp);
                }
                system.debug('PayCodeString**'+MapAccCode);
            }
            // system.debug('ListUpdateSolCompCampTRP**'+ListUpdateSolCompCampTRP);
        }catch(Exception e)  {
            system.debug('EXCEPTION of getCampTRPATCs method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }

        // return SolCompCampTRP;


    } 
    public List<SelectOption> getPayCodesList(String accCodeKey) { 


        List<SelectOption> lstPaycodeValues;
        String reason1;
        try {
            lstPaycodeValues = new List<SelectOption>();
            reason1 = mapAccCode.get(accCodeKey);
            system.debug('Reason1**'+Reason1);
            List<CG_payCodeResJ2A> accountCodeResponse;
            if(reason1 != null){
                accountCodeResponse = (List<CG_payCodeResJ2A>)JSON.deserializeStrict(reason1, List<CG_payCodeResJ2A>.class);
                system.debug('accountCodeResponse-->'+accountCodeResponse);
            }
            lstpaycode = new list<string>();
            if(accountCodeResponse !=null && accountCodeResponse.size()>0){
                // lstpaycode = new list<string>();
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

    //Resetting the updated data to the previous values 
    public void resetAllData(){
        // ListUpdateSolCompCampTRP = getCampTRPATCs();
        system.debug('Resetting***');
        getCampTRPATCs();
    }

    //Method for saving Claim's Data
    /*public void saveClaimData(){
        try{
            List<CSS_Solution_Component__c> lstSolCompToBeUpdated = new List<CSS_Solution_Component__c>();
            if(listSolcompWrapper != null && listSolcompWrapper.size()>0){
                for(SolCompWrapper fcw : listSolcompWrapper){
                    CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
                    solComp.Id = fcw.SolCompId;
                    solComp.Selected_Component__c = fcw.SelectedComp;
                    solComp.Pay_Code__c = fcw.SelectedPayCode;
                    //Saving selected claim type
                    solComp.Claim_Type__c= fcw.Selectedclaimtype;
                    lstSolCompToBeUpdated.add(solComp);
                }
                if(lstSolCompToBeUpdated != null && lstSolCompToBeUpdated.size()>0){
                    update lstSolCompToBeUpdated;
                }
            }
        }catch(Exception e){
            system.debug('EXCEPTION of saveClaimData method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }  
    }*/
    
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