/**********************************************************************
Name:CG_CL_ClaimsPartsandOtherClaimbles
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this Controller for  Claims Parts & Other Claimables
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -      Surender M       02/12/2018          Added Constructor & Updated Navigations 
***********************************************************************/
public class CG_CL_ClaimsPartsandOtherClaimbles
{
    public CG_CL_ClaimsPartsandOtherClaimbles controllerRef{set;get;}
    public Id cId{get;set;} 
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public boolean showErrorPopup{get;set;}
    public String pageName;
    public decimal ConsolidateTemptotal{get;set;}
    public decimal USDTotalwithoutParts{get;set;}
    // public decimal ConsolidateTemptotal{get; set;}
    //TTML Story variables
    public decimal comt {get;set;}       
    public decimal ncomt {get;set;}           
    public decimal towt {get;set;}     
    public decimal meals {get;set;}    
    public decimal lodg {get;set;}    
    public decimal totalexp {get;set;}
    public double temptotalurp{get; set;}
    public decimal partstotalUSd{get; set;}
    public decimal gsqPartsTotalUSD{get; set;} // defect 189638
    public decimal partsUSD{get; set;}
    public Boolean isDealer {get;set;}
    public Boolean psncheck {get;set;}
    public List<CSS_Solution_Component__c> solComps;
    public boolean checkAccountCode{get; set;}
    public Id recTypeIdpart;
    public Boolean partsODMMesasgeflag;
    public List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
    public List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
    public Set<String> errMsgLst{get;set;}
    public List<String> errMsgLstNew{get;set;}
    public boolean isAutomatedDealer{get;set;}
    public static list<CG_ODM_ResJSONParser.message> ODMPartsChevronDisplayMsgs{get;set;}
    public String fieldActionStatus;
    public boolean DealerTypeFlag{get;set;}
    public User userRec{get;set;} 
    public Decimal pocTotalDealer{get;set;} //GSSC-138
    public Decimal pocTotalNonDealer{get;set;} //GSSC-138
    public List<CSS_Parts_Options__c> GSQ_URP_Partslst = new List<CSS_Parts_Options__c>(); //101 SOQL issue fix
    public List<CSS_Parts_Options__c> OC_Partslst = new List<CSS_Parts_Options__c>(); //101 SOQL issue fix
    public List<CSS_Parts_Options__c> TTML_Partslst = new List<CSS_Parts_Options__c>(); //101 SOQL issue fix
    Public Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>(); //GSSC-138
    public Map<Decimal,Decimal> expTotalTempMap = New Map<Decimal,Decimal>();
    public List<CSS_Parts_Options__c> partsListNew = new List<CSS_Parts_Options__c>(); //101 SOQL issue fix
    public List<CSS_Parts_Options__c> failCodePartsList = new List<CSS_Parts_Options__c>(); //101 SOQL issue fix
    public List<CSS_Parts_Options__c> lstPartsRec = new List<CSS_Parts_Options__c>(); //101 SOQL issue fix
    
    //Constructor.
    public CG_CL_ClaimsPartsandOtherClaimbles()
    {
        System.debug('IN CG_CL_ClaimsPartsandOtherClaimbles constructor...');
        
        try {
            //userRec = [SELECT id, DefaultCurrencyIsoCode, CurrencyIsoCode From User Where id =: userInfo.getUserId() limit 1]; //Commented as part of 101 SOQL issue fix
            //system.debug('userRec.CurrencyIsoCode<><>'+userRec.DefaultCurrencyIsoCode);
            psncheck = false;
            checkAccountCode=false;
            solComps = new List<CSS_Solution_Component__c>();
            controllerRef = this;
            cId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('MyClaimId**'+cId);
             //UserRole urRole;
            //urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()]; 
            //User u1 = CSS_utility.getUserAttributes(UserInfo.getUserId()); //Commented as part of 101 SOQL issue fix
            userRec = CSS_utility.getUserAttributes(UserInfo.getUserId()); //Added as part of 101 SOQL issue fix
            if(cId == null) 
            {
                claimsRec = new CSS_Claims__c();  
                psnRec = new CSS_PSN__c();
                totalUSd=0.00;
                ConsolidateTemptotal=0.00;
                gsqPartsTotalUSD = 0.00;
                partstotalUSd = 0.00;
                totalexp =0.00;
                USDTotalval=0.00;
            } else 
            {    
                /*  claimsRec =[Select Id,CSS_Job__r.CreatedDate,Customer_Name__c,Location__c,Location_Code__c,Status__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c, DesignPhaseCode__c,EngineFamilyCode__c,BillToCode__c,SP_TERRITORY_CODE__c,SP_ACCOUNT_STATUS__c,
                    Service_Model__c,CSS_Channel_Of_Distribution__c,SP_CLAIM_ALLOWED_DAYS__c,SP_CMI_SP_EXPIRATION__c,SP_LTA_FLAG__c,OemCode__c,SP_OUTFILE_ALL_CLAIMS__c,SP_PACCAR__c,SP_Region__c,SP_RegionCode__c,
                    (Select Id,Name,PSN__c,Service_Model__c,Application__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,
                    Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, Before_In_Service__c,Qsol_Engine_Family_Code__c,Make__c,ApplicationCode__c,CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                    from CSS_Claims__c where id= :cId]; */
                //Added Engine and SP data as part of ODM
                claimsRec = [Select Id,LastSavedDate__c,IsCopyclaim__c,isAutomatedCopyClaim__c,Last_saved_by__c,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c,ODM_Status__c, Account__r.Type,IsDealerCreatedClaim__c, ReconEngineFlag__c, FieldActionWebServiceResult__c,Dealer_Service_Job__c,CSS_Job__r.CreatedDate,PACCAR_Flag__c,PACCAR_Auth_Required__c,Parts_Warranty_Claim_Only__c,Pending_Authorization__c,Account__c,SP_PrimaryOEMCode__c,Information_Only_Claim__c,Customer_Name__c,Automotive_App_Flag__c,Location__c,Location_Code__c,Status__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c, DesignPhaseCode__c,
                             EngineFamilyCode__c,BillToCode__c,SP_Country__c,EngineFamilyName__c,Account__r.RSS_RESP_BRANCH_CODE__c,SP_TERRITORY_CODE__c,SP_ACCOUNT_STATUS__c,Service_Model__c,CSS_Channel_Of_Distribution__c,SP_CLAIM_ALLOWED_DAYS__c,SP_CMI_SP_EXPIRATION__c,SP_LTA_FLAG__c,OemCode__c,SP_OUTFILE_ALL_CLAIMS__c,SP_PACCAR__c,
                             SP_Region__c,CSS_Channel_Code__c,SP_WarrantyCertificationEndDate__c,SP_RegionCode__c,Account__r.ERP_System__c,CSS_Job__r.Date_in_Shop__c,CSS_Job__r.Date_in__c,CSS_Job__r.Repeat_Or_Recent_Calc__c,CSS_Job__r.RecentVisit__c,Address__c,Authorization_Comments__c,Catastrophic__c,Contact_First_Name__c,
                             Contact_Id__c,Contact_Last_Name__c,Country__c,Customer_Code__c,Customer_Contact_Phone__c,Actual_Technician_Time__c,Customer_Phone__c,TSR1__c, TSR2__c, TSR3__c, TSR4__c, TSR5__c, TSR6__c, TSR7__c, TSR8__c, TSR9__c, TSR10__c,Claims_city__c,
                             Multi_PSN_Claim__c,Distributor_Authorization_FN__c,ProductApplicationCode__c,CSS_Job__r.Status__c,Distributor_Authorization_LN__c,Distributor_Authorization_WWID__c,Email_Address__c,PACCAR_Authorization_FN__c,PACCAR_Authorization_LN__c, EtoConversionDate__c, MarineFlag__c,
                             ProductApplicationDesp__c,warrantyIndicatorFlag__c,PACCAR_Authorization_WWID__c,Repair_Completion__c,Repair_Location__c,Service_Date__c,State__c,ZipCode__c,CSS_Job__r.LastUpdateSubStatus__c,BuildDate__c,SP_CHANNEL_OF_DISTRIBUTION__c,
                             SP_Group_Name__c,SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,Dealer_Service_Job__r.Name,SRT_902_Error_Message__c,
                             SP_TERRITORY__c,(Select Id,Name,PSN__c,Service_Model__c,Application__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, Before_In_Service__c,Qsol_Engine_Family_Code__c,
                                              Make__c,ApplicationCode__c,CSS_Claims__c,Location_Certification__c,Warranty_Authorization_Flag__c,Calibration_After__c,Calibration_Before__c,Justification__c,License_Plate_State__c,Mission_Disabling__c,Model__c,Primary__c,Equipment_ID__c,
                                              Qsol_Technical_Config__c,Qsol_Warranty_Start__c,Unit_Number__c,Unit_Type__c,VIN__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                             from CSS_Claims__c where id= :cId];
                //****************************************************************Getting Multi-PSN chevron basend on condition from Solution component Object 154239 By RAJESH *****************************************************************************************************                
               DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
                //if((claimsRec.Dealer_Service_Job__c!=null || claimsRec.CSS_Job__c!=null) && DealerTypeFlag ==true && urRole.name == 'Factory')
                 if((claimsRec.Dealer_Service_Job__c!=null || claimsRec.CSS_Job__c!=null) && DealerTypeFlag ==true && userRec.UserRoleName__c != null && userRec.UserRoleName__c.contains('Factory')){
                                isAutomatedDealer = true;
                                system.debug('**isAutomatedDealer***'+isAutomatedDealer);
                            } else{
                                //system.debug('**isAutomatedDealer else ***'+isAutomatedDealer);
                                //system.debug('claimsRec.Dealer_Service_Job__c'+claimsRec.Dealer_Service_Job__c);
                                //system.debug('claimsRec.Account__r.Type'+claimsRec.Account__r.Type);
                                isAutomatedDealer = false;
                            }
                                
                
                solComps = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
                            from CSS_Solution_Component__c
                            //where CSS_Claims__c =:claimsRec.id  AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC') AND Selected_Component__c = true) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                            where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                for(css_solution_component__c SC: solComps){
                    if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                        checkAccountCode=true;
                    }
                }
                system.debug('solComps.size()****8'+solComps);
                if(claimsRec!=null && claimsRec.id!=null && checkAccountCode==true){
                    if(claimsRec.Multi_PSN_Claim__c== true)
                    {
                        psncheck = true;
                    }else{
                        psncheck = false;
                    }
                }
                //**************************************************************************END 154239 ************************************************************************************8                 

                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                }else
                    psnRec = new CSS_PSN__c(); 

                solCompList=[Select id,ODM_Status__c,Fail_Code__c,Selected_Component__c,Parts_Warranty__c,In_Shop_SRT_Limit_Flag__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                             from CSS_Solution_Component__c 
                             where CSS_Claims__c = :cId];
                partsList = [Select id, FailurepartId__r.CampaignPartsPercentage__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.Service_Job__c,FailurepartId__r.FailCode_Formula__c, FailurepartId__c, ODM_Status__c,RecordType.Name, Item__c, Unit_Price__c, Get_Fail_Code_Formula__c, selected_part__c, Part_Description__c, Amount__c, ExpenseTotal__c, 
                                    ODM_Status_Message__c, Service_partnumber__c,  Parts_Type__c, Part_Name__c, Quantity__c, HoursTravelled__c, Type__c,
                                    Mileage__c, Quantity_Used__c, Sell_Price__c, Account_Code__c, Fail_Code__c, ReturnToFactory__c, Parts_Return__c, Covered__c,
                                    Comments__c, Warranty_Allocation__c, CSS_Claims__c, Service_Job__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, 
                                    Amount_Local_Currency__c, Part_Assignment__c, Exchange_Rate_Version__c
                             from CSS_Parts_Options__c where CSS_Claims__c = :cId];
                             system.debug('@@@@@partsList'+partsList);
                             
                /*Fix for 101 SOQL issue -- START*/
                
                for(CSS_Parts_Options__c parts : partsList){
                    if(parts.selected_part__c == true && (parts.Parts_Type__c == 'Custom' || parts.Part_Assignment__c == 'Primary' || parts.RecordType.Name == 'Parts')){
                        GSQ_URP_Partslst.add(parts);
                         system.debug('@@@@@GSQ_URP_Partslst'+GSQ_URP_Partslst);
                        system.debug(parts.RecordType.Name + 'parts.RecordType.Name');
                    }
                    
                    else if(parts.RecordType.Name == 'OtherClaimables'){
                        OC_Partslst.add(parts);
                    }
                    else if(parts.RecordType.Name == 'TTML'){
                        TTML_Partslst.add(parts);
                    }
                    if(parts.ReturnToFactory__c == null || parts.ReturnToFactory__c == ''){
                        partsListNew.add(parts);
                    }
                    if(parts.RecordType.Name == 'Parts' && (parts.Fail_Code__c == null || parts.Account_Code__c == null)){
                        failCodePartsList.add(parts);
                    }
                    if(parts.RecordType.Name == 'Parts' && parts.selected_part__c == true){
                        lstPartsRec.add(parts);
                    }
                }
                
                //GSSC-138 - Start
                css_utility controller = new css_utility();
                mapPartsList = controller.displayParts(partslist);
                //GSSC-138 - End
                
                /*Fix for 101 SOQL issue -- END*/
                

                system.debug('claimsRec>>>>:'+claimsRec);
                system.debug('psnRec>>>>:'+psnRec);
                OtherUSd = 0;
                partsUSD=0.00;
                ncomt = 0.00;
                comt = 0.00;
                towt = 0.00;
                meals = 0.00;
                lodg = 0.00;
                totalexp = 0.00;
                totalUSd=0.00;
                gsqPartsTotalUSD = 0.00;
                partstotalUSd = 0.00;
                saveClaimExpenseTotal();
                saveOtherClaimablesTotal();
                USDTotal();
                savePartsTotal();
                //saveGSQPartsTotal(); //defect 189638
                pocTotalDealer = totalUSd + totalexp; //GSSC-138
                pocTotalNonDealer = partstotalUSd + totalUSd + totalexp; //GSSC-138
            }          
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsPartsandOtherClaimbles constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsPartsandOtherClaimbles constructor...');
        isDealer = false;
        //string userType = css_Utility.getOrgType(userinfo.getUserId());
        //claimsRec.IsDealerCreatedClaim__c;
        if(claimsRec.IsDealerCreatedClaim__c !=null && claimsRec.IsDealerCreatedClaim__c == true) {
                isDealer = true;
        }else{
                isDealer = false;
        }

    }
    
    
     public void saveGSQPartsTotal()
    {
        system.debug('This is save GSQ Parts total.');
        try
        {
            gsqPartsTotalUSD = 0.00;
            partsUSD = 0.00;
            List<CSS_Parts_Options__c> partslist = new List<CSS_Parts_Options__c>();
            partslist =[SELECT ExpenseTotal__c,Amount__c,Quantity__c,Covered__c,Unit_Price__c,Get_Fail_Code_Formula__c, Part_Assignment__c FROM CSS_Parts_Options__c WHERE  CSS_Claims__c =:cId AND Part_Assignment__c = 'Primary'];
            if(partslist != null && partslist.size()>0){
                for(CSS_Parts_Options__c csprt:partslist){                
                    if(csprt.Quantity__c!=null)
                    {
                        system.debug('totall'+csprt.Covered__c);
                    system.debug('qty'+csprt.Quantity__c);
                    system.debug('unitpr'+csprt.Unit_Price__c);
                    system.debug('partsusd'+partsUSD);
                        partsUSD=partsUSD+csprt.Quantity__c*((csprt.Covered__c!=null?csprt.Covered__c:0)/100)*(csprt.Unit_Price__c!=null?Decimal.valueof(csprt.Unit_Price__c):0); 
                        system.debug('partsusd'+partsUSD);
                    }
                    //partsUSD=partsUSD+csprt.Quantity__c;
                    gsqPartsTotalUSD=partsUSD;
                    system.debug('totall'+csprt.Covered__c);
                    system.debug('partsUSD'+partsUSD);
                    system.debug('gsqPartsTotalUSD'+gsqPartsTotalUSD);
                } 
            }

        } 
        catch(Exception ex)
        {
            system.debug('Exception in Save Expense method'+ ex.getMessage()+' '+ex.getLineNumber());
        }

    }
    //This method used to get Amount values from Other claimables 

    public void savePartsTotal(){
        system.debug('This is save Parts total.');
        try
        {
            partstotalUSd = 0.00;
            //Commented as part of 101 SOQL issue fix
            /*List<CSS_Parts_Options__c> partslist = new List<CSS_Parts_Options__c>();
            partslist =[SELECT CSS_Claims__c, Service_Job__c, ExpenseTotal__c,Amount__c,Quantity__c,Covered__c,Unit_Price__c,Get_Fail_Code_Formula__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__c WHERE  CSS_Claims__c =:cId AND selected_part__c = true AND (Parts_Type__c = 'Custom' OR Part_Assignment__c = 'Primary' OR RecordType.Name = 'Parts')];
            system.debug('partslist****'+partslist.size());*/
            system.debug('####GSQ_URP_Partslst'+GSQ_URP_Partslst);
            if(GSQ_URP_Partslst != null && GSQ_URP_Partslst.size()>0){
                for(CSS_Parts_Options__c csprt : GSQ_URP_Partslst){
                    //GSSC-138 - Start
                    Map<decimal, decimal> expTotalTempMap = mapPartsList.get(csprt.Id);
                    system.debug(expTotalTempMap + 'expTotalTempMap');
                    Decimal unitPriceTemp; 
                    if(expTotalTempMap != null){
                        for(decimal up : expTotalTempMap.keyset()){
                            unitPriceTemp = up;
                        }
                    }
                    //GSSC-138 - End
                    if(csprt.Quantity__c!=null)
                    {
                        system.debug('totall'+csprt.Covered__c);
                        system.debug('qty'+csprt.Quantity__c);
                        system.debug('unitpr'+csprt.Unit_Price__c);
                        system.debug('partsusd'+partsUSD);
                        //partsUSD=partsUSD+csprt.Quantity__c*((csprt.Covered__c!=null?csprt.Covered__c:0)/100)*(csprt.Unit_Price__c!=null?Decimal.valueof(csprt.Unit_Price__c):0); 
                        partsUSD = partsUSD + csprt.Quantity__c*((csprt.Covered__c!=null?csprt.Covered__c:0)/100)*(unitPriceTemp);  //Changed Unit_Price__c to unitPriceTemp as part of the story GSSC-138
                        system.debug('partsusd'+partsUSD);
                    }
                    //partsUSD=partsUSD+csprt.Quantity__c;
                    partstotalUSd=partsUSD;
                    system.debug('totall'+csprt.Covered__c);
                    system.debug('partsUSD'+partsUSD);
                    system.debug('partstotalUSd'+partstotalUSd);
                } 
            }

        } 
        catch(Exception ex)
        {
            system.debug('Exception in Save Expense method'+ ex.getMessage()+' '+ex.getLineNumber());
        }

    }
    //End
    //This method used to get Amount values from Other claimables 
    public decimal totalUSd{get; set;}
    public decimal OtherUSd{get; set;}

    public void saveOtherClaimablesTotal(){
        system.debug('This is save otherClaims total.');
        try
        {
            OtherUSd = 0.00;
            //Commented as part of 101 SOQL issue fix
            /*List<CSS_Parts_Options__c> cpolist = new List<CSS_Parts_Options__c>();
            cpolist =[SELECT CSS_Claims__c, Service_Job__c, ExpenseTotal__c,Amount__c,Unit_Price__c,Get_Fail_Code_Formula__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__c WHERE RecordType.Name = 'OtherClaimables' AND CSS_Claims__c =:cId ];
            system.debug('cpolist--'+cpolist);*/
            for(CSS_Parts_Options__c csprt : OC_Partslst){
                //GSSC-138 - Start
                Map<decimal, decimal> expTotalTempMap = mapPartsList.get(csprt.Id);
                Decimal expTotalTemp; 
                if(expTotalTempMap != null){
                    for(decimal up : expTotalTempMap.keyset()){
                        expTotalTemp = expTotalTempMap.get(up);
                    }
                }
                //GSSC-138 - End
                if(expTotalTemp!=null)  //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                {
                    //OtherUSd=OtherUSd+csprt.Amount__c;
                    OtherUSd=OtherUSd+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                } 
                totalUSd=OtherUSd;
            } 

            system.debug('**OtherUSd'+OtherUSd);
            system.debug('**totalUSd'+totalUSd);
        } 
        catch(Exception ex)
        {
            system.debug('Exception in Save Expense method'+ ex.getMessage()+' '+ex.getLineNumber());
        }

    }
    //End
    public decimal totalUSd1{get; set;}
    public void saveOtherClaimablesTotal1()
    {
        system.debug('This is save otherClaims total.');
        try
        {
            ConsolidateTemptotal = 0.00;
            List<CSS_Parts_Options__c> existPartList = new List<CSS_Parts_Options__c>();
            existPartList = [SELECT Id, isManual__c,Notes__c, OEM__c, Tracking_Number__c, RID__c,Quantity__c, Selected_part__c, Replacement_Reason__c, Part_Name__c, 
                             Service_partnumber__c, Service_Job__c, Assignment__c, Part_Description__c, Option_Number__c, Part_Assignment__c, 
                             Part_size__c, ReturnToFactory__c, Fail_Code__c, Account_Code__c, Covered__c,Unit_Price__c,Get_Fail_Code_Formula__c
                             FROM CSS_Parts_Options__c WHERE CSS_Claims__c =:cId AND Parts_Type__c = 'Custom'];
            //system.debug('cpolist--'+cpolist);
            for(CSS_Parts_Options__c csprt:existPartList){                
                if(csprt.Covered__c!=null && csprt.Quantity__c!=null)
                {
                    //ConsolidateTemptotal=ConsolidateTemptotal+csprt.Amount__c;
                    ConsolidateTemptotal= ConsolidateTemptotal+(csprt.Covered__c/100)*(csprt.Unit_Price__c!=null?Decimal.valueof(csprt.Unit_Price__c):1)*csprt.Quantity__c;
                    //  OtherUSd=OtherUSd+Decimal.ValueOf(csprt.Amount__c);
                    //  system.debug('**Amount'+Decimal.ValueOf(csprt.Amount__c));
                } 
                totalUSd1+=ConsolidateTemptotal;
                //partOptionWrapperClass temp = new partOptionWrapperClass();
            } 

            //system.debug('**OtherUSd'+OtherUSd);
            //system.debug('**totalUSd'+totalUSd);
        } 
        catch(Exception ex)
        {
            system.debug('Exception in Save Expense method'+ ex.getMessage()+' '+ex.getLineNumber());
        }

    }
    //End

    //This function will give TTML values as per story #115032    
    public void saveClaimExpenseTotal(){    
        system.debug('This is save expense total.');
        try
        {
            ncomt = 0.00;
            comt = 0.00;
            towt = 0.00;
            meals = 0.00;
            lodg = 0.00;
            totalexp = 0.00;
            //Commented as part of 101 SOQL issue fix
            /*List<CSS_Parts_Options__c> cpolist = new List<CSS_Parts_Options__c>();
            cpolist =[SELECT CSS_Claims__c, Service_Job__c, ExpenseTotal__c,Type__c,Unit_Price__c,Get_Fail_Code_Formula__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__c WHERE RecordType.Name = 'TTML' AND CSS_Claims__c =:cId];
            system.debug('cpolist--'+cpolist);*/
            for(CSS_Parts_Options__c csprt : TTML_Partslst){
                //GSSC-138 - Start
                Map<decimal, decimal> expTotalTempMap = mapPartsList.get(csprt.Id);
                Decimal expTotalTemp; 
                if(expTotalTempMap != null){
                    for(decimal up : expTotalTempMap.keyset()){
                        expTotalTemp = expTotalTempMap.get(up);
                    }
                }
                //GSSC-138 - End
                if(csprt.type__c=='Non Commercial-Travel')
                {
                    ncomt=ncomt+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
                if(csprt.type__c=='Commercial-Travel')
                {
                    comt=comt+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
                if(csprt.type__c=='Towing')
                {
                    towt=towt+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
                if(csprt.type__c=='Meals')
                {
                    meals=meals+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
                if(csprt.type__c=='Lodging')
                {
                    lodg=lodg+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
            } 
        
            system.debug('**NCMT'+ncomt); 
            system.debug('**CMT'+comt);
            system.debug('**TWING'+towt);
            system.debug('**MEALS'+meals);
            system.debug('**LODGING'+lodg);
            totalexp=ncomt+comt+towt+meals+lodg;
            system.debug('**TOTALEXP'+totalexp);
        }
        catch(Exception ex)
        {
            system.debug('Exception in Save Expense method'+ ex.getMessage()+' '+ex.getLineNumber());
        }
    }

    //End

    //Page Action.
    public void partsOtherClaimPageAction(){
        try{
            if(cId != null) {
                Map<Id,Id> eprPartListMap = new  Map<Id,Id>();
                List<CSS_Parts_Options__c> eprPartList = new List<CSS_Parts_Options__c>();
                //List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>(); //Commented as part of 101 SOQL issue fix
                //List<CSS_Parts_Options__c> failCodePartsList = new List<CSS_Parts_Options__c>(); //Commented as part of 101 SOQL issue fix
                List<CSS_Parts_Options__c> failCodePartsListUpd = new List<CSS_Parts_Options__c>();
                system.debug('***insidejobPlanAction****');
                //Commented below as part of 101 SOQL issue fix
                //partsList = [select Id, Name, Selected_part__c, FailurepartId__c, Service_partnumber__c,Unit_Price__c,Get_Fail_Code_Formula__c, Account_Code__c, Fail_Code__c, CSS_Claims__c, ReturnToFactory__c, Part_Assignment__c from CSS_Parts_Options__c where CSS_Claims__c =: cId AND ReturnToFactory__c = ''];
                //Return to Factory(EPR Flag) callout
                //eprPartList = CSS_FN_SIEBEL.getPartsReturn(partsList);
                system.debug('***before calling getPartsReturnClaims partsListNew ****'+partsListNew.size());
                if(partsListNew != null && partsListNew.size() > 0) {
                    eprPartList = CSS_FN_SIEBEL.getPartsReturnClaims(partsListNew);
                    //if(eprPartList.size() > 0)
                    //update eprPartList;
                }

                system.debug('fail code copying logic for field actions');
                //Commented below as part of 101 SOQL issue fix
                //failCodePartsList = [SELECT Id, Fail_Code__c,ReturnToFactory__c,Get_Fail_Code_Formula__c,Unit_Price__c, FailurepartId__r.CampaignPartsPercentage__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.Service_Job__c,FailurepartId__r.FailCode_Formula__c, Part_Assignment__c FROM CSS_Parts_Options__c WHERE RecordType.Name = 'Parts' and (Fail_Code__c = null OR Account_Code__c =null)  and CSS_Claims__c =: cId]; //and FailurepartId__r.Type__c IN ('ATC', 'TRP', 'Campaign')
                for(CSS_Parts_Options__c partFailCode : failCodePartsList){
                    CSS_Parts_Options__c singlePart = new CSS_Parts_Options__c();
                    singlePart.Id = partFailCode.Id;
                    List<String> fCode = new List<String>();
                    if(partFailCode.FailurepartId__r.Service_Job__c != null){
                        fCode = partFailCode.Get_Fail_Code_Formula__c.split('-');
                        if(fCode != null && fCode.size() >= 1 && fCode[fCode.size()-1] != null){
                            singlePart.Fail_Code__c = fCode[fCode.size()-1];
                        }
                    }
                    else{
                        if(partFailCode.FailurepartId__r.CampaignPartsPercentage__c != '' && partFailCode.FailurepartId__r.CampaignPartsPercentage__c != null && integer.valueof(partFailCode.FailurepartId__r.CampaignPartsPercentage__c) > 0){
                            fCode = partFailCode.Get_Fail_Code_Formula__c.split('-');
                            if(fCode != null && fCode.size() >= 1 && fCode[fCode.size()-1] != null){
                                singlePart.Fail_Code__c = fCode[fCode.size()-1];
                             }
                             if(partFailCode.FailurepartId__r.CSS_Account_Formula__c!=null && partFailCode.FailurepartId__r.CSS_Account_Formula__c!=''){
                                singlePart.Account_Code__c = partFailCode.FailurepartId__r.CSS_Account_Formula__c;
                             }
                        }
                    }
                    
                     
                    if(partFailCode.FailurepartId__r.FailCode_Formula__c!=null && partFailCode.FailurepartId__r.FailCode_Formula__c!=''
                          && partFailCode.FailurepartId__r.CSS_Account_Formula__c!=null && partFailCode.FailurepartId__r.CSS_Account_Formula__c!=''){
                      //singlePart.Covered__c = 100;
                    }
                    
                   
                  
                    failCodePartsListUpd.add(singlePart); 
                }

                try{    
                    if(eprPartList.size() > 0) 
                        update eprPartList;
                }
                catch(exception e){

                }
                try{
                    if(failCodePartsListUpd.size() > 0)
                        update failCodePartsListUpd;
                }
                
                catch(exception ex){

                }
                //<!--Start  code for getting record type from utility class and showing error when we are not getting Fail and Account code as per story #176379 Kung Fu Panda sprint,-By RAJESH 14th Mar 2019-->                
                CSS_Claims__c claimRecPart = new CSS_Claims__c();
                //list<CSS_Parts_Options__c> lstPartsRec = new list<CSS_Parts_Options__c>(); //Commented as part of 101 SOQL issue fix
                //recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts'); //Commented as part of 101 SOQL issue fix
                    //Added the fields Parts_Type__c, FailurepartId__c in below query as part of the defect # 190951
                    //Commented below as part of 101 SOQL issue fix
                    //lstPartsRec=[SELECT Id,Account_Code__c,Fail_Code__c, Parts_Type__c, FailurepartId__c, Part_Assignment__c from CSS_Parts_Options__c where CSS_Claims__c =:cId and selected_part__c = true and RecordTypeId =: recTypeIdpart];
                    system.debug('***lstPartsRec.size()***'+lstPartsRec.size());
                    if(lstPartsRec.size()>0){
                        for(CSS_Parts_Options__c partsLists:lstPartsRec){
                            system.debug('***partsLists.Fail_Code__c***'+partsLists.Fail_Code__c);
                            system.debug('***partsLists.Account_Code__c***'+partsLists.Account_Code__c);
                             if(partsLists.Fail_Code__c=='Select One' || partsLists.Account_Code__c=='Select One' || partsLists.Account_Code__c=='' || partsLists.Account_Code__c==null){
                                 system.debug('***inside parts with dealer location***');
                                 //Added below if condition as part of the defect # 190951
                                 if(((partsLists.Parts_Type__c == null || partsLists.Parts_Type__c == '') && partsLists.FailurepartId__c != null) || (partsLists.Parts_Type__c != null && partsLists.Parts_Type__c != '')){
                                    partsODMMesasgeflag=true;
                                 }
                             }
                        }
                    }
                    if(partsODMMesasgeflag==true){
                        claimRecPart.id=cId;
                        claimRecPart.PartsRelatedODMMessage__c='failed';
                        update claimRecPart;
                    }
                    else{
                        claimRecPart.id=cId;
                        claimRecPart.PartsRelatedODMMessage__c='passed';
                        update claimRecPart;
                    }
                    system.debug('***claimRecPart***'+claimRecPart);
                    //Added as part of the story #179800
                    CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                    contr.covLimitValidation(null, cId, null, null);
                    
                    system.debug('***isDealer***'+isDealer);
                   /*if(claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null){//commented by RAJESH because we need to call  covLimitValidationTTML for all claims
                        CG_CL_CoverageLimitExceedValidation contr1 = new CG_CL_CoverageLimitExceedValidation();
                        contr1.covLimitValidationTTML(null,cId,null,true);
                    }*/
                    contr.covLimitValidationTTML(null,cId,null,true);
                    // <!--End  code for getting record type from utility class and showing error when we are not getting Fail and Account code as per story #176379 Kung Fu Panda sprint,-By RAJESH 14th Mar 2019-->                
            
                //Admin SRT 00-902-00 error message logic below
                CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
            
            }  
        } catch(exception e){
            system.debug('exception in partsOtherClaimPageAction with the error ' + e.getMessage() + ' at the line ' + e.getLineNumber());
        }  
    }
    //Page Action.


    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsIntake(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsIntake';

        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,Type__c,ODM_Status__c,Fail_Code__c,Selected_Component__c,RoadRelay_Warranty__c,In_Shop_SRT_Limit_Flag__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c, Part_Assignment__c
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];

        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        
        List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
        system.debug('fieldActionsLst-->'+fieldActionsLst);
        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement.     
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            if(callPartsOnInfoOnlyClaim == true){
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
            ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        /****************************************************************************************************************************/
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 
            }
        }
        if(fieldActionsLst != null && fieldActionsLst.size() > 0){
            insert fieldActionsLst;
        }
        
        CSS_Claims__c claimsUpd = new CSS_Claims__c();
        claimsUpd.Id = cId;
        
        system.debug('After insert fieldActionsLst-->'+fieldActionsLst);
        if(fieldActionStatus != null && fieldActionStatus != ''){
            //claimsRec.FieldActionWebServiceResult__c = fieldActionStatus;
            claimsUpd.FieldActionWebServiceResult__c = fieldActionStatus;
            if(claimsUpd.Id != null){
                update claimsUpd;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }

    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsWC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsWarranty';

        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,ODM_Status__c,Fail_Code__c,Selected_Component__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c 
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];


        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        
        List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
      

        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement.     
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            if(callPartsOnInfoOnlyClaim == true) {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        /****************************************************************************************************************************/
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsWarranty'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); 
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }

    //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsVH';
        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,ODM_Status__c,Fail_Code__c,Selected_Component__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c 
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];

        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        
       List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure

        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement.     
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            if(callPartsOnInfoOnlyClaim == true){
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        /****************************************************************************************************************************/

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVH'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsVH?id='+cId); 
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }

    //Naviagation to Customer Complaint.
    public PageReference nvClaimsCC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsCC';
        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,ODM_Status__c,Fail_Code__c,Selected_Component__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c 
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];


        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        
        List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure

        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement.     
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            if(callPartsOnInfoOnlyClaim == true){
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
            ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
        }
        }
        /****************************************************************************************************************************/
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }

    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsFC';
        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,ODM_Status__c,Fail_Code__c,Type__c,Selected_Component__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c 
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];


        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        
        List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure

        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement.     
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            if(callPartsOnInfoOnlyClaim == true){
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
               ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
        }
        }
        /****************************************************************************************************************************/
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }

    //Added below Method as per Silicon Valley sprint #154239 -By RAJESH 20th Aug 2018   
    public PageReference nvClaimsPSN(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsMultiPSN';
        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,ODM_Status__c,Fail_Code__c,Selected_Component__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c 
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];


        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure

        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement.     
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            if(callPartsOnInfoOnlyClaim == true){
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
            ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
        }
        }
        /****************************************************************************************************************************/

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsMultiPSN?id='+cId); 
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }
    
    public PageReference nvClaimsPOC(){
        return null;
    }

    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsSRTs';
        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,Type__c,ODM_Status__c,Fail_Code__c,Selected_Component__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c 
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];  


        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure

        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement. 
            system.debug('***jobid***'+claimsRec.CSS_Job__c);
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
              //  system.debug('showErrorPopup--->>'+showErrorPopup);
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            system.debug('inside distr');
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            system.debug('callPartsOnInfoOnlyClaim-->>'+callPartsOnInfoOnlyClaim);
            if(callPartsOnInfoOnlyClaim == true){
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                system.debug('showErrorPopup--->>'+showErrorPopup);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
                //system.debug('showErrorPopup--->>'+showErrorPopup);
            }
        }
        /****************************************************************************************************************************/
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); 
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }

    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsJobNotes';
        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,Type__c,ODM_Status__c,Fail_Code__c,Selected_Component__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c 
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];


        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure

        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement.     
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            if(callPartsOnInfoOnlyClaim == true){
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
            ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();  
            }
        }
            
        /****************************************************************************************************************************/

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); 
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }

    //Naviagation to Verify and Submit
    public PageReference nvClaimsVS(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        pageName='CG_ClaimsVS';
        //cId = saveClaim(cId, 'Draft');
        solCompList=[Select id,Type__c,ODM_Status__c,Fail_Code__c,Selected_Component__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c = :cId];
        partsList = [Select id,ODM_Status__c,Item__c,Unit_Price__c,Get_Fail_Code_Formula__c,selected_part__c,Part_Description__c,Amount__c,ExpenseTotal__c,ODM_Status_Message__c,Service_partnumber__c,RecordType.Name,Parts_Type__c,Part_Name__c,Quantity__c,HoursTravelled__c,Type__c,Mileage__c,Quantity_Used__c,Sell_Price__c,Account_Code__c, Fail_Code__c,ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c 
                     from CSS_Parts_Options__c where CSS_Claims__c = :cId];


        //Method to call ODM webservice validation service
        //  showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMOtherClaimableValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //CG_BL_ODM.callODMTravelValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList);
        //Method to call ODM webservice validation service
        //showErrorPopup=true;
        //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
        /****************************************************************************************************************************/
        boolean callPartsOnInfoOnlyClaim;
        //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
        Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
        
        List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure

        IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
        {
            //If the information only check box is checked then claims cannot receive warranty reimbursement.     
            if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null)) { 
                showErrorPopup = false;
            }
            else //Else go ahead and do ODM validation
            {
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        else//Distributor eligible for automated and manual claim hence no condition
        {
            for(CSS_Solution_Component__c scomp:solCompList)
            {
                if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                {
                    callPartsOnInfoOnlyClaim = false;
                    break;
                }
                else
                {
                    callPartsOnInfoOnlyClaim = true;

                }
            }
            if(callPartsOnInfoOnlyClaim == true){
                showErrorPopup = CG_BL_ODM.callClaimsODMPartsValidationService(null,claimsRec,psnRec,'CLAIM',solCompList,partsList,isDealer);
                ODMPartsChevronDisplayMsgs =CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
            }
        }
        /****************************************************************************************************************************/
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId);
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        
        //Admin SRT 00-902-00 error message logic below
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(cId, claimsRec);
        
        return pageRef;
    }
    
    public List<CSS_Solution_Component__c> CampaignsWSCall(){
        // calling FieldAction WebService in case of failure response on chevron navigation
        try{
        system.debug('CampaignsWSCall >>' + claimsRec.FieldActionWebServiceResult__c);
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
            string FailureDateString;
            if(psnRec.Failure_Date__c != null){
                FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
            }
            HttpResponse httpRes;
            httpRes = CG_BL_Campaigns.callGetCampaignsWSforClaimsRetrigger(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
            system.debug('****httpRes****'+httpRes);
            
    if(httpRes == null || httpRes.getStatusCode() != 200){
        fieldActionStatus = 'Error';
    }
    else if(httpRes != null && httpRes.getStatusCode() == 200){
        fieldActionStatus = 'Success';
        CG_OP_CampaignsResJSON outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(httpRes.getBody(), CG_OP_CampaignsResJSON.class);
                system.debug('outputRes**'+outputRes);
                list<CG_BL_Campaigns.CampaignsWrapper> CampaignsWrapperList = new list<CG_BL_Campaigns.CampaignsWrapper>();
                
                if(outputRes.DataArea != null){
                    system.debug('outputRes.DataArea ' + outputRes.DataArea);
                    List<CSS_Parts_Options__c> partsOptionList;
                    Id recTypeId = [SELECT Id FROM RecordType WHERE Name =: 'Parts'].Id;
                    Map<String,List<CSS_Parts_Options__c>> wsDataMap = new Map<String,List<CSS_Parts_Options__c>>();
                    
                    system.debug('claimsRec'+claimsRec);
                    
                    for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                        system.debug('det.Status ' + det.Status);
                        //Here check Siebel Campaigns are meeting required criteria
                        if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                            continue;
                        if(det.Status == 'Approved' ){
                            CSS_Solution_Component__c campaignComp = new CSS_Solution_Component__c();
                            if(det.InShopSrtLimitFlag == 'Y'){
                                campaignComp.In_Shop_SRT_Limit_Flag__c = true;
                            }
                            else{
                                campaignComp.In_Shop_SRT_Limit_Flag__c = false;
                            }
                            campaignComp.Campaign_Description__c = det.CampaignDesc; 
                            if(det.CampaignEndDate != null && det.CampaignEndDate != ''){
                                campaignComp.Campaign_End_Date__c = date.valueof(det.CampaignEndDate);
                            }
                            if(det.CampaignStartDate != null && det.CampaignStartDate != ''){
                                campaignComp.Campaign_Start_Date__c = date.valueof(det.CampaignStartDate);
                            }
                            if(det.CampaignNumber != null){
                                campaignComp.Component_Id__c = string.valueof(det.CampaignNumber);
                            }
                            campaignComp.Failure_Mode__c = det.FailMode;
                            if(det.FailCode != null && det.FailCode != ''){
                                campaignComp.System_Code__c = (det.FailCode).substring(0,2);
                                campaignComp.Component_Code__c = (det.FailCode).substring(2);
                            }
                            campaignComp.Status__c = det.Status;
                            if(det.MultipleTimes == 'Y'){
                                campaignComp.Multiple_Times__c = true;
                            }
                            else{
                                campaignComp.Multiple_Times__c = false;
                            }
                            campaignComp.Business_Unit__c = det.BusinessUnit;
                            campaignComp.Type__c = det.CampaignType;
                            campaignComp.Name = det.CampaignType+' '+det.CampaignNumber;
                            campaignComp.Status__c = det.Status;
                            if(det.CompleteIndicator == 'Y'){
                                campaignComp.Complete_Indicator__c = true;
                            }
                            else{
                                campaignComp.Complete_Indicator__c = false;
                            }
                            campaignComp.css_claims__c = cId; 
    
                            //calling detail coverage as per story 184437 to check coverage before fieldaction insert
    
                            CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
                            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,String.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,campaignComp.System_Code__c,campaignComp.Component_Code__c,'','',null,false,campaignComp.Component_Id__c,'','Second Call', claimsRec.ReconEngineFlag__c,false,claimsRec.Name);
                            if(comp != null){  
                                System.debug('comp****' + comp);
                                system.debug('comp.AccountCode__c'+comp.AccountCode__c);
                                if(comp.AccountCode__c!=null && comp.AccountCode__c!=''){
                                    solCompList.add(campaignComp);
                                    system.debug('campaignComp ' + campaignComp);
                                }
                            }
                        }
                    }
    
                    //Delete old saved solution comp & parts data for the job
                    /*List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>([Select Id from CSS_Solution_Component__c where css_claims__c=:cId and Type__c in ('CAMPAIGN','TRP','ATC')]);                
    
                    if(solCompListTemp !=null && solCompListTemp.size()>0){
                        List<CSS_Parts_Options__c> partsListTemp = new List<CSS_Parts_Options__c>([Select Id, Name from CSS_Parts_Options__c where CSS_Claims__c=:cId and RecordTypeId=:recTypeId and FailurepartId__c in :solCompListTemp]);                     
                        System.debug('partsListTemp>>>:'+partsListTemp);
                        if(partsListTemp !=null && partsListTemp.size() > 0)
                            delete partsListTemp; 
                        List<CSS_SRT__c> srtsListTemp = new List<CSS_SRT__c>([Select Id from CSS_SRT__c where CSS_Claims__c =: cId and (Type__c = 'Field Action' OR Type__c = 'Field Action Access')]);
                        if(srtsListTemp != null && srtsListTemp.size() > 0)
                            delete srtsListTemp; 
                        delete solCompListTemp;
                    }*/
    
                    if(solCompList !=null && solCompList.size() > 0){
                        for(CSS_Solution_Component__c sc : solCompList) {
                            CampaignsWrapperList.add(new CG_BL_Campaigns.CampaignsWrapper(cId,sc.System_Code__c,sc.Component_Code__c,sc.Id,sc.Component_Id__c,sc.Selected_Component__c));     
                        }
                    }
                    system.debug('solCompList'+solCompList.size());
                    system.debug('solCompList-->'+solCompList);

                    system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
                    system.debug('START QUEUEABLE SOLUTION COMPONENT');
                    system.debug('Claims**CampaignsWrapperList ' + CampaignsWrapperList);
                    ID jobIDs = System.enqueueJob(new CG_ClaimsQueueable(CampaignsWrapperList));
                    System.debug('END QUEUEABLE SOLUTION COMPONENT');
                    system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
        
                }      
    }
    
       }
        
            
            return solCompList;
        }
        catch(Exception ex){
           system.debug('Exception in CampaignsWSCall method  ex.getMessages()' + ex.getmessage() + 'ex.getLineNumber ' + ex.getLineNumber() );
           return null;
        }
        
    }
    
    public PageReference pageReferenceMethod()
    {
        if(CID!=null)
            return new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cID);
        else
            return new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles');
    }

    //Method for resolving error in ODM Validation services
    public PageReference resolveErrorNow()
    {
        PageReference pageRef;
        showErrorPopup = false;
        pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId);
        pageRef.setRedirect(true);
        return pageRef;
    }

    //Method for continuing to clicked chevron in ODM Validation services
    public PageReference continueNext()
    {
        PageReference pageRef;
        if(pageName != '' && pageName !=null){
            if(cId==null){
                pageRef = new pageReference('/apex/'+pageName); 
            }else{
                pageRef = new pageReference('/apex/'+pageName+'?id='+cId); 
            }
            return pageRef;
        }
        else
            return null;
    }


    //Bottom save button 
    public PageReference pgSave()
    {
        PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl());
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }

    public decimal USDTotalval{get;set;}


    public void USDTotal()
    {
        USDTotalval = 0;
        try
        {
            //Defect 153922 Test: Rupesh
            //The total here is P+O+T where P is parts and O is other claimables and T is TTML

            //totalexp//This is TTML 
            system.debug('Total TTML'+totalexp);
            //totalUSd//This is Other Claimables
            system.debug('Total OtherClaimables'+totalUSd);
            //USDTotalval=partsUSD;
            system.debug('Total Parts'+partstotalUSd);
            USDTotalval=totalexp+totalUSd+partstotalUSd;
            USDTotalwithoutParts = totalexp+totalUSd;
        }
        catch(Exception ex)
        {
            system.debug('Exception in USDTotal method'+ ex.getMessage()+' '+ex.getLineNumber());
        }
    }
}