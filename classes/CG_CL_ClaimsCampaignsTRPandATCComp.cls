/*
* Block comments with details of changes
*/
/**********************************************************************
Name:CG_CL_ClaimsCampaignsTRPandATCComp
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Campaigns, TRPs, and ATCs Component Controller                                                      
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -   KRISHNA        04/08/2018         INITIAL DEVELOPMENT  
1.0 -   Prabhakar      10/08/2018        ACTION METHOD LOGIC 
1.0 -   Rupesh         13/08/2018        QUANTITY CALCULATION  
=======================================================================
***********************************************************************/
public class CG_CL_ClaimsCampaignsTRPandATCComp 
{
    public Id cId{get; set;}
    public CSS_Claims__c claimsRec{set;get;}
    //public CSS_PSN__c psnRec{set;get;}
    // public Boolean isAutomatedClaim{get;set;}
    //Three list of campains/trp and atcs
    public list<CSS_Parts_Options__c> campains{get; set;}
    public list<CSS_Parts_Options__c> trps{get; set;}
    public list<CSS_Parts_Options__c> atcs{get; set;}
    public String errorMsg {get;set;}
    public Boolean errorMsg1 {get;set;} 
    public Boolean errorMsgTRP {get;set;} 
    public Boolean errorMsgATC {get;set;} 
    public String tnumber {get;set;}
    public Boolean rWaiver {get;set;}
    public list<CSS_Solution_Component__c> campPartlstUI;//TO query
    public list<CSS_Solution_Component__c> TrpPartlstUI;//To query
    public list<CSS_Solution_Component__c> AtcPartlstUI;//To query

    //public list<CSS_Solution_Component__c> AllPartlstUI;//Rupesh


    public list<CompWrapper> listcompWrapper {get;set;}//Campaign Wrapper
    public list<CompWrapper> listTRPcompWrapper {get;set;}//TRP Wrapper
    public list<CompWrapper> listATCcompWrapper {get;set;}//ATC Wrapper

    public list<PartWrapper> listPartWrapper {get;set;}
    public list<PartWrapper> listTRPPartWrapper {get;set;}
    public list<PartWrapper> listATCPartWrapper {get;set;}


    public  Boolean isSaved {get;set;}
    public  Boolean isReset {get;set;}
    public string selectedRecordRowID {get; set;}

    public Id pgId {get; set;}
    public boolean trackingNumberCMPBoo{get; set;}
    public boolean trackingNumberTRPBoo{get; set;}
    public boolean trackingNumberATCBoo{get; set;}
    public Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>(); //GSSC-138
    public CG_CL_ClaimsCampaignsTRPandATCComp() 
    {

        system.debug('inside class...');
        //errorMsg='';
        cId = ApexPages.CurrentPage().getParameters().get('Id');
        if(cId !=null)
            claimsRec = [select id,css_job__c, Account__c, Account__r.Type from CSS_Claims__c where id=:cId];
        isSaved = false;
        isReset = false;
        //psnRec = [select id,Multi_PSN_Claim__c from CSS_PSN__c where id=:cId];
        // isAutomatedClaim = false;
        //getAllTRPPartsData(); //Commented as part of 101 SOQL issue fix
    }
    

    public void campPartsDetails()
    {
        system.debug('Testing....');
        //Since the line "//ATClisttobeUpdated.add(parts); " in below 3 for loops are commented already, the other code snippets become invalid.
        //Hence commenting them as part of 101 SOQL issue fix.
        /*getAllCampPartsData();
        getAllTRPPartsData();
        getAllATCPartsData();
        
        List<CSS_Parts_Options__c> ATClisttobeUpdated = new List<CSS_Parts_Options__c>();
        if(AtcPartlstUI!=null){
            for(CSS_Solution_Component__c solcomp : AtcPartlstUI)
            {
                for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r)
                    {
                        if(parts.ReturnWaiver__c==true && parts.Tracking_Number__c!='Select One' && parts.Tracking_Number__c!=''){
                            parts.ReturnWaiver__c=false;
                            //ATClisttobeUpdated.add(parts);            
                        }
                    }
                
            }
           
        }
        
         if(TrpPartlstUI!=null){
            for(CSS_Solution_Component__c solcomp : TrpPartlstUI)
            {
                for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r)
                    {
                        if(parts.ReturnWaiver__c==true && parts.Tracking_Number__c!='Select One' && parts.Tracking_Number__c!=''){
                            parts.ReturnWaiver__c=false;
                           // ATClisttobeUpdated.add(parts);            
                        }
                    }
                
            }
            
        }
        
         if(campPartlstUI!=null){
            for(CSS_Solution_Component__c solcomp : campPartlstUI)
            {
                for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r)
                    {
                        if(parts.ReturnWaiver__c==true && parts.Tracking_Number__c!='Select One' && parts.Tracking_Number__c!=''){
                            parts.ReturnWaiver__c=false;
                           // ATClisttobeUpdated.add(parts);            
                        }
                    }
                
            }
          
        }
             
             if(ATClisttobeUpdated!=null && ATClisttobeUpdated.size()>0){
                update ATClisttobeUpdated;
            }*/
        List<CSS_Solution_Component__c> partLstUI = new List<CSS_Solution_Component__c>();
        List<CSS_Parts_Options__c> fieldActionPartsLst = new List<CSS_Parts_Options__c>();
        if(cId != null){
            if(claimsRec.CSS_Job__c!=NULL)
            {
                partLstUI = [select Id, Service_Job__c, Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,CSS_Claims__c,
                                 (select Id, RecordTypeId,Service_Job__c, Covered__c, Account_Code__c,Unit_Price__c,ExpenseTotal__c,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,ReturnWaiver__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,CSS_Claims__c, RID__c, Tracking_Number__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c 
                                  from CSS_Parts_Options__r) 
                                 from CSS_Solution_Component__c where Type__c IN ('Campaign', 'TRP', 'ATC') and Selected_Component__c=true and CSS_Claims__c =:cId and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false)) and CSS_Account_Formula__c!=null];
            }
            else
            {
                partLstUI = [select Id, Service_Job__c, Type__c,Selected_Component__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,CSS_Claims__c,
                                 (select Id, RecordTypeId,Service_Job__c, Unit_Price__c, Account_Code__c, ExpenseTotal__c,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,ReturnWaiver__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,CSS_Claims__c, RID__c, Tracking_Number__c,Covered__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c
                                  from CSS_Parts_Options__r) 
                                 from CSS_Solution_Component__c where Type__c IN ('Campaign', 'TRP', 'ATC') and Selected_Component__c=true and CSS_Claims__c =:cId and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];

            }
        }
        if(partLstUI != null && partLstUI.size() > 0){
            campPartlstUI = new list<CSS_Solution_Component__c>();
            TrpPartlstUI = new list<CSS_Solution_Component__c>(); 
            AtcPartlstUI = new list<CSS_Solution_Component__c>();
            for(CSS_Solution_Component__c sc :partLstUI){
                if(sc.Type__c == 'Campaign'){
                    campPartlstUI.add(sc);
                }
                else if(sc.Type__c == 'TRP'){
                    TrpPartlstUI.add(sc);
                }
                else if(sc.Type__c == 'ATC'){
                    AtcPartlstUI.add(sc);
                }
                for(CSS_Parts_Options__c part : sc.CSS_Parts_Options__r){
                    fieldActionPartsLst.add(part);
                }
            }
        }
        
        //GSSC-138 - Start
        css_utility controller = new css_utility();
        mapPartsList = controller.displayParts(fieldActionPartsLst);
        //GSSC-138 - End
        getAllCampPartsData();
        getAllTRPPartsData();
        getAllATCPartsData();
    }
    
    public void getAllCampPartsData()
    {
        //campPartlstUI = new list<CSS_Solution_Component__c>(); //Commented as part of 101 SOQL issue fix
        try
        { 
            if(cId != null) 
            {
                system.debug('Claims Id >>>>>>>>>Campaigns>>>: '+cId);
                //Commented as part of 101 SOQL issue fix - Start
                /*
                //Added Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c in below query as part of the story GSSC-138
                if(claimsRec.CSS_Job__c!=NULL)
                {
                    campPartlstUI = [select Id, Service_Job__c, Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,CSS_Claims__c,
                                     (select Id, Service_Job__c, Covered__c, Account_Code__c,Unit_Price__c,ExpenseTotal__c,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,ReturnWaiver__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,CSS_Claims__c, RID__c, Tracking_Number__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c 
                                      from CSS_Parts_Options__r) //where selected_part__c=true) //commented as per #179606
                                     from CSS_Solution_Component__c where Type__c='Campaign' and Selected_Component__c=true and CSS_Claims__c =:cId and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false)) and CSS_Account_Formula__c!=null];
                    system.debug('campPartlstUI: '+campPartlstUI);
                }
                else
                {
                    campPartlstUI = [select Id, Service_Job__c, Type__c,Selected_Component__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,CSS_Claims__c,
                                     (select Id, Service_Job__c, Unit_Price__c, Account_Code__c, ExpenseTotal__c,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,ReturnWaiver__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,CSS_Claims__c, RID__c, Tracking_Number__c,Covered__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c
                                      from CSS_Parts_Options__r) 
                                     from CSS_Solution_Component__c where Type__c='Campaign' and Selected_Component__c=true and CSS_Claims__c =:cId and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
                    system.debug('campPartlstUIManual: '+campPartlstUI);

                }
                //GSSC-138 - Start
                List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
                for(CSS_Solution_Component__c sc : campPartlstUI){
                    for(CSS_Parts_Options__c p : sc.CSS_Parts_Options__r){
                        partsList.add(p);
                    }
                }
                
                Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
                css_utility controller = new css_utility();
                mapPartsList = controller.displayParts(partsList);
                //GSSC-138 - End
                //Commented as part of 101 SOQL issue fix - Start
                */
                integer Compcount = 0;
                if(campPartlstUI!=null){
                    listcompWrapper = new List<compWrapper>();
                    for(CSS_Solution_Component__c solcomp : campPartlstUI){
                        if(solcomp != null)
                        {
                            Compcount = Compcount + 1;
                            integer partcount = 0;
                            string percentageCov;
                            listPartWrapper = new list<PartWrapper>();
                            system.debug('Outsidepartcount*'+partcount);
                            for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r)
                            {
                                partcount = partcount + 1;
                                system.debug('Insidepartcount*'+partcount);
                                if(parts.CSS_Claims__c == solcomp.CSS_Claims__c){
                                    if(solcomp.Id == parts.FailurepartId__c){
                                        if(solcomp.CampaignPartsPercentage__c == '0' || solcomp.CampaignPartsPercentage__c == null || solcomp.CampaignPartsPercentage__c == ''){
                                            percentageCov = '0';
                                        }
                                        else
                                            percentageCov = '100';
                                            
                                        //GSSC-138 - Start
                                        Map<decimal, decimal> expTotalTempMap = mapPartsList.get(parts.Id);
                                        Decimal unitPriceTemp; 
                                        if(expTotalTempMap != null){
                                            for(decimal up : expTotalTempMap.keyset()){
                                                unitPriceTemp = up;
                                            }
                                        }
                                        unitPriceTemp = unitPriceTemp == 0 ? 0.00 : unitPriceTemp;
                                        //GSSC-138 - End
                                        
                                        //listpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.Account_Code__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,String.valueof(parts.ReturnWaiver__c),solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Tracking_Number__c,parts.RID__c,parts.Unit_Price__c,String.valueof(parts.ExpenseTotal__c),false,false));
                                        listpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.Account_Code__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,String.valueof(parts.ReturnWaiver__c),solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Tracking_Number__c,parts.RID__c,string.valueof(unitPriceTemp),String.valueof(parts.ExpenseTotal__c),false,false));
                                    }
                                }

                                system.debug('listpartWrapper**'+listpartWrapper);
                            }
                            listcompwrapper.add(new compwrapper(solComp.id,solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,listpartWrapper,partcount));
                            system.debug('listcompwrapper**'+listcompwrapper);
                        }                
                    }
                }
            }
        }catch(Exception ex)
        {
            System.debug('in catch of CampPartsData of CSS_Parts_Options__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        populateTotalAmountCAM();
    }

    public void populateTotalAmountCAM()
    {
        try
        {
            system.debug('inside method');
            if(listPartWrapper != null && listPartWrapper.size()>0)
            {
                system.debug('listcompWrapper'+listPartWrapper);

                for(integer i=0;i<listPartWrapper.size();i++)
                {
                    system.debug('listTRPpartWrapper[i].quantity'+listPartWrapper[i].quantity);
                    if(listPartWrapper[i].quantity!=null)
                    {
                        integer camperreq = Integer.valueOf(listPartWrapper[i].covered)/100;
                        system.debug('listTRPpartWrapper[i].Totprice'+listPartWrapper[i].Totprice);
                        listPartWrapper[i].Totprice = String.valueOf(Decimal.valueof(listPartWrapper[i].quantity) * (listPartWrapper[i].UnitPrice!=null?Decimal.valueof(listPartWrapper[i].UnitPrice):0)*(camperreq));
                    }
                }
            }
        }
        catch(exception e)
        {
            system.debug(' catch block of populate amount value' + ' ' + e.getLineNumber() + ' ' + e.getMessage() );
        }
    }

    public void getAllTRPPartsData()
    {

        system.debug('***Inside getTRPPartsData Function.***');
        //TrpPartlstUI = new list<CSS_Solution_Component__c>();   //Commented as part of 101 SOQL issue fix

        try{
            if(cId != null) 
            {
                //Commented as part of 101 SOQL issue fix - Start
                /*
                //Added Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c in below query as part of the story GSSC-138
                if(claimsRec.CSS_Job__c!=NULL)
                {
                    system.debug('JobID>>>>>>>>>TRP>>>: '+cId);
                    TrpPartlstUI = [select Id, Service_Job__c, Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,CSS_Claims__c,
                                    (select Id, Service_Job__c, Covered__c,Account_Code__c,Unit_Price__c,ReturnWaiver__c, ExpenseTotal__c,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,CSS_Claims__c, RID__c, Tracking_Number__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c 
                                     from CSS_Parts_Options__r)// where selected_part__c=true) 
                                    from CSS_Solution_Component__c where Type__c='TRP' and CSS_Claims__c =:cId and Selected_Component__c=true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false)) and CSS_Account_Formula__c!=null];
                    system.debug('TrpPartlstUI: '+TrpPartlstUI);
                }
                else
                {
                    TrpPartlstUI = [select Id, Service_Job__c, Selected_Component__c,Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,CSS_Claims__c,
                                    (select Id, Service_Job__c, Unit_Price__c,Account_Code__c,ExpenseTotal__c,ReturnWaiver__c, FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,CSS_Claims__c, RID__c, Tracking_Number__c,Covered__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c 
                                     from CSS_Parts_Options__r) 
                                    from CSS_Solution_Component__c where Type__c='TRP' and Selected_Component__c=true and CSS_Claims__c =:cId and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
                    system.debug('TrpPartlstUIManual: '+TrpPartlstUI);
                }
                //GSSC-138 - Start
                List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
                for(CSS_Solution_Component__c sc : TrpPartlstUI){
                    for(CSS_Parts_Options__c p : sc.CSS_Parts_Options__r){
                        partsList.add(p);
                    }
                }
                system.debug('partsList--->'+partsList.size());
                Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
                css_utility controller = new css_utility();
                mapPartsList = controller.displayParts(partsList);
                system.debug('mapPartsList-->'+mapPartsList);
                //GSSC-138 - End
                //Commented as part of 101 SOQL issue fix - End
                */
                if(TrpPartlstUI!=null){
                    listTRPcompWrapper = new List<compWrapper>();
                    for(CSS_Solution_Component__c solcomp : TrpPartlstUI)
                    {
                        if(solcomp != null)
                        {
                            integer partcount = 0;
                            String percentageCov;
                            listTRPPartWrapper = new list<PartWrapper>();
                            system.debug('Outsidepartcount*'+partcount);
                            for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r)
                            {

                                partcount = partcount + 1;
                                system.debug('Insidepartcount*'+partcount);
                                if(parts.CSS_Claims__c == solcomp.CSS_Claims__c)
                                {
                                    if(solcomp.Id == parts.FailurepartId__c)
                                    {
                                        if(solcomp.CampaignPartsPercentage__c == '0' || solcomp.CampaignPartsPercentage__c == null || solcomp.CampaignPartsPercentage__c == ''){
                                            percentageCov = '0';
                                        }
                                        else
                                            percentageCov = '100';
                                        
                                        //GSSC-138 - Start
                                        Map<decimal, decimal> expTotalTempMap = mapPartsList.get(parts.Id);
                                        Decimal unitPriceTemp; 
                                        if(expTotalTempMap != null){
                                            for(decimal up : expTotalTempMap.keyset()){
                                                unitPriceTemp = up;
                                            }
                                        }
                                        system.debug('unitPriceTemp-->'+unitPriceTemp);
                                        unitPriceTemp = unitPriceTemp == 0 ? 0.00 : unitPriceTemp;
                                        //GSSC-138 - End
                                        
                                        //listTRPpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.Account_Code__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,String.valueof(parts.ReturnWaiver__c),solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Tracking_Number__c,parts.RID__c,parts.Unit_Price__c,String.valueof(parts.ExpenseTotal__c),false,false));
                                        listTRPpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.Account_Code__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,String.valueof(parts.ReturnWaiver__c),solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Tracking_Number__c,parts.RID__c,string.valueof(unitPriceTemp),String.valueof(parts.ExpenseTotal__c),false,false));
                                    }
                                }

                                system.debug('listTRPpartWrapper**'+listTRPpartWrapper);
                            }
                            listTRPcompwrapper.add(new compwrapper(solComp.id,solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,listTRPpartWrapper,partcount));
                            system.debug('listTRPcompwrapper**'+listTRPcompwrapper);
                        }
                        system.debug('before calling populateTotalAmountTRP listTRPpartWrapper:'+listTRPpartWrapper);
                        populateTotalAmountTRP();
                   		system.debug('final after total price listTRPpartWrapper**'+listTRPpartWrapper); 
                    }
                }
            }
            

        }catch(Exception ex)
        {
            System.debug('in catch of TRPPartsData of CSS_Parts_Options__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    public void populateTotalAmountTRP(){
        try
        {
            system.debug('inside method');
            if(listTRPpartWrapper != null && listTRPpartWrapper.size()>0)
            {

                system.debug('listTRPpartWrapper'+listTRPpartWrapper);

                for(integer i=0;i<listTRPpartWrapper.size();i++)
                {
                    system.debug('listTRPpartWrapper[i].quantity'+listTRPpartWrapper[i].quantity);
                    if(listTRPpartWrapper[i].quantity!=null)
                    {
                        integer trpreq = Integer.valueOf(listTRPpartWrapper[i].covered)/100;
                        system.debug('listTRPpartWrapper[i].Totprice'+listTRPpartWrapper[i].Totprice);
                        listTRPpartWrapper[i].Totprice = String.valueOf(Decimal.valueof(listTRPpartWrapper[i].quantity) * (listTRPpartWrapper[i].UnitPrice!=null?Decimal.valueof(listTRPpartWrapper[i].UnitPrice):0)*(trpreq));

                    }
                }
            }
        }
        catch(exception e)
        {
            system.debug(' catch block of populate amount value' + ' ' + e.getLineNumber() + ' ' + e.getMessage() );
        }
    }
    
    public void getAllATCPartsData(){

        //AtcPartlstUI = new list<CSS_Solution_Component__c>(); //Commented as part of 101 SOQL issue fix


        try{
           if(cId != null) {
               //Commented as part of 101 SOQL issue fix - Start
               /*
               //Added Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c in below query as part of the story GSSC-138
                if(claimsRec.CSS_Job__c!=NULL)
                {
                    system.debug('JobID>>>>>>>>>ATC>>>: '+cId);
                    AtcPartlstUI = [select Id, Service_Job__c, Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,CSS_Claims__c,
                                    (select Id, Service_Job__c, Covered__c,Unit_Price__c,ExpenseTotal__c,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,CSS_Claims__c, RID__c, Tracking_Number__c,ReturnWaiver__c, Account_Code__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c
                                     from CSS_Parts_Options__r)// where selected_part__c=true) 
                                    from CSS_Solution_Component__c where Type__c='ATC' and CSS_Claims__c =:cId and Selected_Component__c=true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false)) and CSS_Account_Formula__c!=null];
                    system.debug('AtcParlsUI: '+AtcPartlstUI);
                }
                else
                {
                    AtcPartlstUI = [select Id, Service_Job__c, Type__c,Selected_Component__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,CSS_Claims__c,
                                    (select Id, Service_Job__c, Unit_Price__c,ExpenseTotal__c,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,CSS_Claims__c, RID__c, Tracking_Number__c,Covered__c,ReturnWaiver__c, Account_Code__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c
                                     from CSS_Parts_Options__r) 
                                    from CSS_Solution_Component__c where Type__c='ATC' and Selected_Component__c=true and CSS_Claims__c =:cId and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
                    system.debug('AtcParlsUI-manualclaim: '+AtcPartlstUI);
                }
                //GSSC-138 - Start
                List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
                for(CSS_Solution_Component__c sc : AtcPartlstUI){
                    for(CSS_Parts_Options__c p : sc.CSS_Parts_Options__r){
                        partsList.add(p);
                    }
                }
                
                Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
                css_utility controller = new css_utility();
                mapPartsList = controller.displayParts(partsList);
                //GSSC-138 - End
                //Commented as part of 101 SOQL issue fix - End
                */
                if(AtcPartlstUI!=null){
                    listATCcompWrapper = new List<compWrapper>();
                    for(CSS_Solution_Component__c solcomp : AtcPartlstUI)
                    {
                        if(solcomp != null){
                            integer partcount = 0;
                            String percentageCov;
                            listATCPartWrapper = new list<PartWrapper>();
                            system.debug('Outsidepartcount*'+partcount);
                            integer i = 0;
                            for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r)
                            {
                                partcount = partcount + 1;
                                system.debug('solcomp.CSS_Parts_Options__r.Id-->'+parts.Id);
                                system.debug('solcomp.CSS_Parts_Options__r-->'+parts.Service_partnumber__c);
                                system.debug('solcomp.CSS_Parts_Options__r-->'+parts.ReturnWaiver__c);
                                system.debug('tracking number-->'+parts.Tracking_Number__c);
                                system.debug('Insidepartcount*'+partcount);
                                if(parts.CSS_Claims__c == solcomp.CSS_Claims__c)
                                {
                                    if(solcomp.Id == parts.FailurepartId__c){
                                        if(solcomp.CampaignPartsPercentage__c == '0' || solcomp.CampaignPartsPercentage__c == null || solcomp.CampaignPartsPercentage__c == ''){
                                            percentageCov = '0';
                                        }
                                        else
                                            percentageCov = '100';
                                            
                                        //GSSC-138 - Start
                                        Map<decimal, decimal> expTotalTempMap = mapPartsList.get(parts.Id);
                                        Decimal unitPriceTemp; 
                                        if(expTotalTempMap != null){
                                            for(decimal up : expTotalTempMap.keyset()){
                                                unitPriceTemp = up;
                                            }
                                        }
                                        system.debug('unitPriceTemp-->'+unitPriceTemp);
                                        unitPriceTemp = unitPriceTemp == 0 ? 0.00 : unitPriceTemp;
                                        //GSSC-138 - End
                                        
                                        //listATCpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.Account_Code__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,String.valueof(parts.ReturnWaiver__c),solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Tracking_Number__c,parts.RID__c,parts.Unit_Price__c,String.valueof(parts.ExpenseTotal__c),false,false));
                                        listATCpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.Account_Code__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,String.valueof(parts.ReturnWaiver__c),solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Tracking_Number__c,parts.RID__c,string.valueof(unitPriceTemp),String.valueof(parts.ExpenseTotal__c),false,false));
                                    }
                                }
                                system.debug('listATCpartWrapper----->'+listATCpartWrapper[i]);
                                i++;
                                system.debug('listATCpartWrapper**'+listATCpartWrapper);
                            }
                            listATCcompwrapper.add(new compwrapper(solComp.id,solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,listATCpartWrapper,partcount));
                            system.debug('listATCcompwrapper**'+listATCcompwrapper);
                       }                
                    }
                }
            }

        }catch(Exception ex)
        {
            System.debug('in catch of ATCPartsData of CSS_Parts_Options__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        populateTotalAmountATC();  

    }

    public void populateTotalAmountATC(){
        try
        {
            system.debug('inside method');
            // if(listTRPcompwrapper != null && listTRPcompwrapper.size()>0)
            if(listATCPartWrapper != null && listATCPartWrapper.size()>0)
            {

                system.debug('listTRPpartWrapper'+listATCPartWrapper);

                for(integer i=0;i<listATCPartWrapper.size();i++)
                {
                    system.debug('listTRPpartWrapper[i].quantity'+listATCPartWrapper[i].quantity);
                    if(listATCPartWrapper[i].quantity!=null)
                    {
                        //integer camperreq = Integer.valueOf(listTRPpartWrapper[i].covered)/100;
                        integer atcreq = Integer.valueOf(listATCPartWrapper[i].covered)/100;
                        listATCPartWrapper[i].Totprice = String.valueOf(Decimal.valueof(listATCPartWrapper[i].quantity) * (listATCPartWrapper[i].UnitPrice!=null?Decimal.valueof(listATCPartWrapper[i].UnitPrice):0)*(atcreq));

                    }
                }
            }
        }
        catch(exception e)
        {
            system.debug(' catch block of populate amount value' + ' ' + e.getLineNumber() + ' ' + e.getMessage() );
        }
    }

    public void ResetCTAData(){
        getAllCampPartsData();
        getAllTRPPartsData();
        getAllATCPartsData();
        isReset = true;
    }

    public void saveCTAData(){
        //AllPartlstUI = new list<CSS_Solution_Component__c>();//Rupesh
        errorMsg1=false;
        errorMsgTRP=false;
        errorMsgATC=false; 
        List<CSS_Parts_Options__c> partlstcamp = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> partlstTrp = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> partlstAtc = new List<CSS_Parts_Options__c>();

        //Create a consolidated list of all CAM/TRP AND ACT data
        List<CSS_Parts_Options__c> allPartsList = new List<CSS_Parts_Options__c>();

        List<CSS_Solution_Component__c> solcomplsttrp = new List<CSS_Solution_Component__c>();
        List<CSS_Solution_Component__c> solcomplstAtc = new List<CSS_Solution_Component__c>();
        system.debug('New List'+partlstcamp.size());
        set<boolean> setTrackingNumReqErrorMessageCMP = new set<boolean>();
        set<boolean> setTrackingNumReqErrorMessageTRP = new set<boolean>();
        set<boolean> setTrackingNumReqErrorMessageATC = new set<boolean>();
        try
        {
            system.debug('inside save method');
            system.debug('CampPartsList*'+listpartWrapper);
            system.debug('CampPartsList1**'+listcompwrapper);

            //SAVING OF CAMPAIGN EMBEDDED LIST..IN Parts Options object
            if(listcompwrapper != null && listcompwrapper.size()>0)
            {
                for(CompWrapper CompWrap: listcompwrapper)
                {
                    for(PartWrapper partwrap : CompWrap.partWrapper)
                    {
                        system.debug('InsideFor*');
                        partwrap.returnWaiverSelected = false;
                        CSS_Parts_Options__c partscamp = new CSS_Parts_Options__c();
                        partscamp.Id = partwrap.partids;
                        partscamp.selected_part__c = partwrap.selectedComponent;
                        if(partwrap.quantity == '' || partwrap.quantity == null)
                            partwrap.quantity = '0';
                        partscamp.Quantity__c = Decimal.valueOf(partwrap.quantity);
                        system.debug('Quantity-PartNumber'+partwrap.quantity+'-'+partwrap.servicepart);
                        system.debug('**********partwrap.returnWaiver***'+partwrap.returnWaiver);
                        system.debug('**********partwrap.trackingNumber***'+partwrap.trackingNumber);
                        if(partwrap.returnWaiver=='true' && partwrap.trackingNumber=='Select One' && partwrap.returnToFactory == 'Y' && partwrap.selectedComponent == true){
                            system.debug('*****Inside If ***');
                           //errorMsg1=true;
                          // partscamp.Tracking_Number__c = null;
                            partwrap.returnWaiverSelected = true;
                            partwrap.trackingNumberReq=true;
                            setTrackingNumReqErrorMessageCMP.add(true);
                           // errorMsg= Label.CG_Please_enter_value;
                        }
                        else if(partwrap.trackingNumber!='' && partwrap.trackingNumber!='Select One' && partwrap.returnToFactory == 'Y' && partwrap.selectedComponent == true){
                            system.debug('*****Inside else If ***');
                            //errorMsg1=false;
                            partwrap.trackingNumberReq=false;
                            partscamp.Tracking_Number__c = partwrap.trackingNumber;
                            setTrackingNumReqErrorMessageCMP.add(false);
                        }
                        else if(partwrap.returnWaiver=='false' && (partwrap.trackingNumber=='Select One' || partwrap.trackingNumber=='' || partwrap.trackingNumber==null) && partwrap.returnToFactory == 'Y' && partwrap.selectedComponent == true){
                            system.debug('*****Inside inside else If ***');
                            //errorMsg1=false;
                            partwrap.trackingNumberReq=true;
                            //partscamp.Tracking_Number__c =null;
                            setTrackingNumReqErrorMessageCMP.add(true);
                        }
                        else if(partwrap.selectedComponent == false && (partwrap.trackingNumber=='Select One' || partwrap.trackingNumber=='' || partwrap.trackingNumber==null)){
                            partwrap.trackingNumberReq=false;
                            setTrackingNumReqErrorMessageCMP.add(false);
                        }
                        //partscamp.Tracking_Number__c = partwrap.trackingNumber;
                        partscamp.RID__c = partwrap.RID;
                        if(partwrap.returnWaiver == 'true')
                            partscamp.ReturnWaiver__c = true;
                        else
                            partscamp.ReturnWaiver__c = false;
                        if(partwrap.covered != null && partwrap.covered != '')
                            partscamp.Covered__c = integer.valueOf(partwrap.covered);
                        partscamp.ExpenseTotal__c = (partwrap.Totprice != null && partwrap.Totprice != '' ? decimal.valueOf(partwrap.Totprice) : 0.0);
                        partscamp.CSS_Claims__c = cId;
                        allPartsList.add(partscamp);
                    }
                }
                system.debug('InsideIF*');
                system.debug('solcomplst*'+partlstcamp);
                
                if(setTrackingNumReqErrorMessageCMP.contains(true)){
                    errorMsg1=true;
                }
                else{
                    errorMsg1=false;
                }
            } 
            system.debug('TRPPartsList*'+listTRPpartWrapper);

            //SAVING OF TRP EMBEDDED LIST..IN Parts Options object
            if(listTRPcompwrapper != null && listTRPcompwrapper.size()>0)
            {

                for(CompWrapper compwraptrp : listTRPcompwrapper){
                    for(PartWrapper partwraptrp : compwraptrp.partWrapper)
                    {
                        system.debug('InsideFor*');
                        partwraptrp.returnWaiverSelected = false;
                        CSS_Parts_Options__c partstrp = new CSS_Parts_Options__c();
                        partstrp.Id = partwraptrp.partids;
                        partstrp.selected_part__c = partwraptrp.selectedComponent;
                        if(partwraptrp.quantity == '' || partwraptrp.quantity == null)
                            partwraptrp.quantity = '0';
                        partstrp.Quantity__c = Decimal.valueOf(partwraptrp.quantity);                        
                        // partstrp.Tracking_Number__c = partwraptrp.trackingNumber;
                        partstrp.RID__c = partwraptrp.RID;
                        if(partwraptrp.returnWaiver == 'true')
                            partstrp.ReturnWaiver__c = true;
                        else
                            partstrp.ReturnWaiver__c = false;
                        system.debug('**********partwrap.returnWaiver***'+partwraptrp.returnWaiver);
                        system.debug('**********partwrap.trackingNumber***'+partwraptrp.trackingNumber);
                        system.debug('**********partwraptrp.returnToFactory***'+partwraptrp.returnToFactory);
                        system.debug('**********partwraptrp.selectedComponent***'+partwraptrp.selectedComponent);
                        system.debug('**********partwraptrp.servicepart***'+partwraptrp.servicepart);
                        if( partwraptrp.trackingNumber=='Select One' && partwraptrp.returnWaiver=='true' && partwraptrp.returnToFactory == 'Y' && partwraptrp.selectedComponent == true){
                            system.debug('******Inside if for TRP****');
                            //errorMsgTRP=true;
                           // partstrp.Tracking_Number__c = null;
                            partwraptrp.trackingNumberReq=true;
                            partwraptrp.returnWaiverSelected = true;
                            setTrackingNumReqErrorMessageTRP.add(true);
                            system.debug('******partwraptrp.returnWaiverSelected****'+partwraptrp.returnWaiverSelected);
                            errorMsg= Label.CG_Please_enter_value;
                        }
                        else if((partwraptrp.trackingNumber=='Select One' || partwraptrp.trackingNumber=='' || partwraptrp.trackingNumber==null) && partwraptrp.returnWaiver=='false' && partwraptrp.returnToFactory == 'Y' && partwraptrp.selectedComponent == true){
                            system.debug('******Inside if for TRP2****');
                            //errorMsgTRP=true;
                          //  partstrp.Tracking_Number__c = null;
                            partwraptrp.trackingNumberReq=true;
                            partwraptrp.returnWaiverSelected = true;
                            setTrackingNumReqErrorMessageTRP.add(true);
                            system.debug('******partwraptrp.returnWaiverSelected2****'+partwraptrp.returnWaiverSelected);
                            errorMsg= Label.CG_Please_enter_value;
                        }
                        else if(partwraptrp.trackingNumber!='' && partwraptrp.trackingNumber!='Select One' && partwraptrp.returnToFactory == 'Y' && partwraptrp.selectedComponent == true){
                            system.debug('******Inside else if for TRP****');
                            partstrp.Tracking_Number__c = partwraptrp.trackingNumber;
                            //errorMsgTRP=false;
                            partwraptrp.trackingNumberReq=false;
                            setTrackingNumReqErrorMessageTRP.add(false);
                        }
                        else if(partwraptrp.selectedComponent == false && (partwraptrp.trackingNumber=='Select One' || partwraptrp.trackingNumber=='' || partwraptrp.trackingNumber==null)){
                            partwraptrp.trackingNumberReq=false;
                            setTrackingNumReqErrorMessageTRP.add(false);
                        }
                        /*else if(partwraptrp.returnWaiver=='false' && partwraptrp.trackingNumber=='Select One'){
                            system.debug('******Inside else else if for TRP****');
                            errorMsgTRP=false;
                            partwraptrp.trackingNumberReq=false;
                            partstrp.Tracking_Number__c = null;
                        }*/
                        if(partwraptrp.covered != null && partwraptrp.covered != '')
                            partstrp.Covered__c = integer.valueOf(partwraptrp.covered);
                        partstrp.ExpenseTotal__c = (partwraptrp.Totprice != null && partwraptrp.Totprice != '' ? decimal.valueOf(partwraptrp.Totprice) : 0.0);
                        partstrp.CSS_Claims__c = cId;
                        allPartsList.add(partstrp);
                    }
                }
                system.debug('InsideIF*');
                system.debug('partlstTrp*'+partlstTrp);
                
                
                if(setTrackingNumReqErrorMessageTRP.contains(true)){
                    errorMsgTRP=true;
                }
                else{
                    errorMsgTRP=false;
                }
            }

            //SAVING OF ATC EMBEDDED LIST...IN Parts Options object
            if(listATCcompwrapper != null && listATCcompwrapper.size()>0)
            {
                for(CompWrapper CompWrapAtc: listATCcompwrapper)
                {
                    for(PartWrapper partatcwrap : CompWrapAtc.partwrapper)
                    {
                         partatcwrap.returnWaiverSelected = false;
                        if(partatcwrap != null)
                        {
                            CSS_Parts_Options__c partsAtc = new CSS_Parts_Options__c();
                            partsAtc.Id = partatcwrap.partids;
                            partsAtc.selected_part__c = partatcwrap.selectedComponent;
                            if(partatcwrap.quantity == '' || partatcwrap.quantity == null)
                                partatcwrap.quantity = '0';
                            partsAtc.Quantity__c = decimal.valueOf(partatcwrap.quantity);
                            partsAtc.RID__c = partatcwrap.RID;
                           if(partatcwrap.returnWaiver == 'true')
                                partsAtc.ReturnWaiver__c = true;
                            else
                                partsAtc.ReturnWaiver__c = false;
                        system.debug('**********partwrap.returnWaiver***'+partatcwrap.returnWaiver);
                        system.debug('**********partwrap.trackingNumber***'+partatcwrap.trackingNumber);
                        system.debug('**********partwrap.errorMsgATC***'+errorMsgATC);
                            if(partatcwrap.trackingNumber=='Select One' && partatcwrap.returnWaiver=='true' && partatcwrap.returnToFactory == 'Y' && partatcwrap.selectedComponent == true){
                                system.debug('******Inside  if for ATC****');
                                //errorMsgATC=true;
                                //partsAtc.Tracking_Number__c = null;
                                partatcwrap.trackingNumberReq=true;
                                partatcwrap.returnWaiverSelected = true;
                                setTrackingNumReqErrorMessageATC.add(true);
                                errorMsg= Label.CG_Please_enter_value;
                            }
                            else if(partatcwrap.trackingNumber!='' && partatcwrap.trackingNumber!='Select One' && partatcwrap.returnToFactory == 'Y' && partatcwrap.selectedComponent == true){
                                system.debug('******Inside else if for ATC****');
                                //errorMsgATC=false;
                                partatcwrap.trackingNumberReq=false;
                                partsAtc.Tracking_Number__c = partatcwrap.trackingNumber;
                                setTrackingNumReqErrorMessageATC.add(false);
                            }
                            else if((partatcwrap.trackingNumber=='Select One' || partatcwrap.trackingNumber=='' || partatcwrap.trackingNumber==null) && partatcwrap.returnWaiver=='false' && partatcwrap.returnToFactory == 'Y' && partatcwrap.selectedComponent == true){
                                system.debug('**********Inside else else if for ATC**********');
                                //partsAtc.Tracking_Number__c = null;
                                partatcwrap.trackingNumberReq=true;
                                setTrackingNumReqErrorMessageATC.add(true);
                            }
                            else if(partatcwrap.selectedComponent == false && (partatcwrap.trackingNumber=='Select One' || partatcwrap.trackingNumber=='' || partatcwrap.trackingNumber==null)){
                                partatcwrap.trackingNumberReq=false;
                                setTrackingNumReqErrorMessageATC.add(false);
                            }
                            if(partatcwrap.covered != null && partatcwrap.covered != '')
                                partsAtc.Covered__c = integer.valueOf(partatcwrap.covered);
                            
                            partsAtc.ExpenseTotal__c = (partatcwrap.Totprice != null && partatcwrap.Totprice != '' ? decimal.valueOf(partatcwrap.Totprice) : 0.0);
                            partsAtc.CSS_Claims__c = cId;                           
                            allPartsList.add(partsAtc);

                        }
                    }
                }
                
                if(setTrackingNumReqErrorMessageATC.contains(true)){
                    errorMsgATC=true;
                }
                else{
                    errorMsgATC=false;
                }
            }
            system.debug('isSavedInitially**'+isSaved);
            system.debug('allPartsList * '+allPartsList);
            if(allPartsList != null && allPartsList.size()>0)
            {
                update allPartsList;
                isSaved = true;
                system.debug('isSAved***'+isSaved);}
            system.debug('allPartsList * '+allPartsList);

        }catch(exception e)
        {

            system.debug('Entered into catch block of save parts method in css_CampaignController class' );
            system.debug('Campaign Controller Exception --> '+ e.getLineNumber() + ' ' +e.getMessage() );
        }            
    }

    public List<SelectOption> getreplacementReasonOptions(){    
        try
        {
            System.debug('CampParts***');
            List<SelectOption> options =  new List<SelectOption>();    
            Schema.DescribeFieldResult fieldResult = CSS_Parts_Options__c.Replacement_Reason__c.getDescribe();    
            List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();    
            for(Schema.picklistEntry f:ple)    
            {    
                if(f.getValue()!='GSQ Part')
                options.add(new selectOption(f.getLabel(),f.getValue()));                    
            }    
            return Options; 
        }
        catch(exception e)
        {
            return null;
        }
    } 
    //Solution component wrapper (Child of claim) Solution component has many parts
    public class CompWrapper{
        public Id CompIds {get;set;}
        public string FieldActNum {get;set;}
        public integer partcount{get;set;}
        public list<PartWrapper> partWrapper {get;set;}
        public CompWrapper(Id CompIds,string FieldActNum,list<PartWrapper> partWrapper,integer partcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.partWrapper = partWrapper;
            this.partcount = partcount;

        }
    }
    //Method for getting picklist values for Tracking Number as per 24 sprint #161414,-By RAJESH 04th Sec 2018
    public List<SelectOption> getTrackNumberNew(){
        system.debug('inside getTrackingNumber Method');
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption('Select One','Select One'));
        options.add( new SelectOption('Progressive Damage','Progressive Damage'));
        options.add( new SelectOption('Claim Refile','Claim Refile'));
        options.add( new SelectOption('Not Returned','Not Returned'));
        options.add( new SelectOption('EPR Restricted','EPR Restricted'));    
        return options;
    }
    //End 
    //Part option wrapper (Child of Claim)/Child of Solution component
         public class PartWrapper{
        public Id partids {get;set;}
        public Boolean selectedComponent {get;set;}
        //There will be 14 max columns in Campaigns, TRPs, and ATCs
        public String fieldactnum {get;set;}
        public String type {get;set;}
        public String accountcode {get;set;}
        public String quantity {get;set;}
        public String servicepart {get;set;}
        public String oem {get;set;}
        public String partname {get;set;}
        public String returnToFactory {get;set;}
        public String returnWaiver {get;set;}
        public String covered {get;set;}
        public String failcode {get;set;}
        public String trackingNumber {get;set;}
        public String RID {get;set;}
        public string UnitPrice {get;set;}
        public String Totprice{get;set;}
        public boolean returnWaiverSelected{get;set;}
        public boolean trackingNumberReq{get;set;}
        public PartWrapper(Id partids,Boolean selectedcomponent,String fieldactnum,String type,String accountcode,String quantity,String servicepart,String oem,String partname,String returnToFactory,String returnWaiver,String covered,String failcode,String tNumber,String ridValue,string uprvalue,string tprvalue, boolean returnWaiverSelected, boolean trackingNumberReq) 
        {
            this.partids = partids;
            this.selectedComponent = selectedcomponent;
            this.fieldactnum = fieldactnum;
            this.type = type;
            this.accountcode=accountcode;
            this.quantity = quantity;
            this.servicepart = servicepart;
            this.oem = oem;
            this.partname = partname;
            this.returnToFactory = returnToFactory;
            this.returnWaiver = returnWaiver;
            this.covered = covered;
            this.failcode = failcode;
            this.trackingNumber = tNumber;
            this.RID = ridValue;
            this.UnitPrice=uprvalue;
            this.Totprice=tprvalue;
            this.returnWaiverSelected=returnWaiverSelected;
            this.trackingNumberReq=trackingNumberReq;
        }
    }

        public void enableTNDropDownCAMPAIGN(){
        system.debug('tnumber-->'+tnumber);
            system.debug('before errorMsg1-->'+errorMsg1);
            errorMsg1=false;
            system.debug('After errorMsg1-->'+errorMsg1);
            system.debug('listcompWrapper-->'+listcompWrapper);
        for(compWrapper parentWarrperCam:listcompWrapper){
            for(PartWrapper childrapperCam:parentWarrperCam.partWrapper){
                if(childrapperCam.servicepart==tnumber){
                    childrapperCam.returnWaiver = string.valueof(rWaiver);
                    childrapperCam.returnWaiverSelected = false;
                    break;                    
                }
            }
        }
    }
    
        public void enableTNDropDownTRP(){
        system.debug('tnumber-->'+tnumber);
        errorMsgTRP=false;
        for(compWrapper parentWarrper:listTRPcompWrapper){
            for(PartWrapper childrapper:parentWarrper.partWrapper){
                if(childrapper.servicepart==tnumber){
                    childrapper.returnWaiver = string.valueof(rWaiver);
                    childrapper.returnWaiverSelected = false;
                    break;                    
                }
            }
        }
    }
    
        public void enableTNDropDownATC(){
        system.debug('tnumber-->'+tnumber);
            errorMsgATC=false;
        for(compWrapper parentWarrperATC:listATCcompWrapper){
            for(PartWrapper childrapperATC:parentWarrperATC.partWrapper){
                if(childrapperATC.servicepart==tnumber){
                    childrapperATC.returnWaiver = string.valueof(rWaiver);
                    childrapperATC.returnWaiverSelected = true;
                    break;                    
                }
            }
        }
    }
    
}