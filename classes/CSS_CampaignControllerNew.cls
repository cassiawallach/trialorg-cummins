/*
 * Block comments with details of changes
 */
public class CSS_CampaignControllerNew
{
    public Id Wid;
    public list<CSS_Parts_Options__c> campains{get; set;}
    public list<CSS_Parts_Options__c> trps{get; set;}
    public list<CSS_Parts_Options__c> atcs{get; set;}
    public list<CSS_Solution_Component__c> campPartlstUI;
    public list<CSS_Solution_Component__c> TrpPartlstUI;
    public list<CSS_Solution_Component__c> AtcPartlstUI;
    public list<CSS_Solution_Component__c> AllPartlstUI;
    public list<CompWrapper> listcompWrapper {get;set;}
    public list<PartWrapper> listPartWrapper {get;set;}
    public List<CSS_Job_Order__c>workjob{get;set;}

    public list<CompWrapper> listTRPcompWrapper {get;set;}
    public list<PartWrapper> listTRPPartWrapper {get;set;}

    public list<CompWrapper> listATCcompWrapper {get;set;}
    public list<PartWrapper> listATCPartWrapper {get;set;}
    public  Boolean isSaved {get;set;}
    public  Boolean isReset {get;set;}
    
    public id pgId {get; set;}
    public CSS_CampaignControllerNew()
    {
        system.debug('inside class...');
        Wid=ApexPages.CurrentPage().getParameters().get('id');
       // getAllCampPartsData();
       // getAllTRPPartsData();
       // getAllATCPartsData();
        isSaved = false;
        isReset = false;

    }
    
    public void campPartsDetails(){
     system.debug(' Testing,,,,');
     List<CSS_Solution_Component__c> partLstUI = new List<CSS_Solution_Component__c>();
    partLstUI =[select Id,Type__c,Component_Id__c,Campaign_Description__c,FailCode_Formula__c,CampaignPartsPercentage__c,Service_Job__c,
                             (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                              from CSS_Parts_Options__r) 
                             from CSS_Solution_Component__c where Type__c IN ('Campaign', 'TRP', 'ATC') and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
    
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
        }
    }
        getAllCampPartsData();
        getAllTRPPartsData();
        getAllATCPartsData();
    }
    
    public void getAllCampPartsData(){

        //campPartlstUI = new list<CSS_Solution_Component__c>(); 

        try{
            system.debug('JobID>>>>>>>>>campParts>:'+Wid);
            /* Commented as part of 101 SOQL issue fix 
            campPartlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,FailCode_Formula__c,CampaignPartsPercentage__c,Service_Job__c,
                             (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,FailurepartId__r.FailCode_Formula__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                              from CSS_Parts_Options__r) 
                             from CSS_Solution_Component__c where Type__c='Campaign' and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            */
            //Boolean compParts = false;

            integer Compcount = 0;
            if(campPartlstUI!=null){
                listcompWrapper = new List<compWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : campPartlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        integer partcount = 0;
                        string percentageCov;
                        listPartWrapper = new list<PartWrapper>();
                        system.debug('Outsidepartcount*'+partcount);
                        for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r){
                            partcount = partcount + 1;
                            system.debug('Insidepartcount*'+partcount);
                            if(parts.Service_Job__c == solcomp.Service_Job__c){
                                //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                                //compParts = true;
                                if(solcomp.Id == parts.FailurepartId__c){
                                    if(solcomp.CampaignPartsPercentage__c == '0' || solcomp.CampaignPartsPercentage__c == null || solcomp.CampaignPartsPercentage__c == ''){
                                        percentageCov = '0';
                                    }
                                    else
                                        percentageCov = '100';
                                    listpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.FailurepartId__r.CSS_Account_Formula__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Replacement_Reason__c,parts.Notes__c,partcount,percentageCov));
                                }
                                //system.debug('listpartcampWrapper**'+listpartcampWrapper);
                            }

                            system.debug('listpartWrapper**'+listpartWrapper);
                        }
                        listcompwrapper.add(new compwrapper(solComp.id,solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,listpartWrapper,partcount));
                        system.debug('listcompwrapper**'+listcompwrapper);
                    }                
                }
            }
        }catch(Exception ex){
            System.debug('in catch of CampPartsData of CSS_Parts_Options__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    public void getAllTRPPartsData(){

        //TrpPartlstUI = new list<CSS_Solution_Component__c>(); 

        try{
            system.debug('JobID>>>>>>>>>campParts>:'+Wid);
            /*Commented as part of 101 SOQL issue fix
            TrpPartlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,FailCode_Formula__c,CampaignPartsPercentage__c,Service_Job__c,
                            (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.FailCode_Formula__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                             from CSS_Parts_Options__r) // where Service_Job__c =:Wid
                            from CSS_Solution_Component__c where Type__c='TRP' and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            */
            //Boolean compParts = false;

            // integer Compcount = 0;
            if(TrpPartlstUI!=null){
                listTRPcompWrapper = new List<compWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : TrpPartlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        // Compcount = Compcount + 1;
                        integer partcount = 0;
                        String percentageCov;
                        listTRPPartWrapper = new list<PartWrapper>();
                        system.debug('Outsidepartcount*'+partcount);
                        for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r){
                           // partcount = partcount + 1;
                            system.debug('Insidepartcount*'+partcount);
                            system.debug('parts.Service_Job__c' + ' ' + parts.Service_Job__c) ;
                            system.debug('solcomp.Service_Job__c' + ' ' + solcomp.Service_Job__c) ;
                            system.debug('solcomp.Id' + ' ' + solcomp.Id) ;
                            system.debug('parts.FailurepartId__c' + ' ' + parts.FailurepartId__c) ;
                            if(parts.Service_Job__c == solcomp.Service_Job__c){
                                //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                                //compParts = true;
                                 
                                if(solcomp.Id == parts.FailurepartId__c){
                                    if(solcomp.CampaignPartsPercentage__c == '0' || solcomp.CampaignPartsPercentage__c == null || solcomp.CampaignPartsPercentage__c == ''){
                                        percentageCov = '0';
                                    }
                                    else
                                        percentageCov = '100';
                                    partcount = partcount + 1;
                                    listTRPpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.FailurepartId__r.CSS_Account_Formula__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Replacement_Reason__c,parts.Notes__c,partcount,percentageCov));
                                    
                                }
                                //system.debug('listpartcampWrapper**'+listpartcampWrapper);
                            }

                            system.debug('listTRPpartWrapper**'+listTRPpartWrapper);
                        }
                        listTRPcompwrapper.add(new compwrapper(solComp.id,solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,listTRPpartWrapper,partcount));
                        system.debug('listTRPcompwrapper**'+listTRPcompwrapper);
                    }                
                }
            }
        }catch(Exception ex){
            System.debug('in catch of TRPPartsData of CSS_Parts_Options__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    public void getAllATCPartsData(){

        //AtcPartlstUI = new list<CSS_Solution_Component__c>(); 

        try{
            system.debug('JobID>>>>>>>>>campParts>:'+Wid);
            /*Commented as part of 101 SOQL issue fix
            AtcPartlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,Service_Job__c,FailCode_Formula__c,
                            (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.FailCode_Formula__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                             from CSS_Parts_Options__r) 
                            from CSS_Solution_Component__c where Type__c='ATC' and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            */
            //Boolean compParts = false;
             system.debug('AtcParlsUI:'+AtcPartlstUI);
            // integer Compcount = 0;
            if(AtcPartlstUI!=null){
                listATCcompWrapper = new List<compWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : AtcPartlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        // Compcount = Compcount + 1;
                        integer partcount = 0;
                        String percentageCov;
                        listATCPartWrapper = new list<PartWrapper>();
                        system.debug('Outsidepartcount*'+partcount);
                        for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r){
                            partcount = partcount + 1;
                            system.debug('Insidepartcount*'+partcount);
                            system.debug('parts.Quantity__c>>>>>*'+parts.Quantity__c);
                            
                            if(parts.Service_Job__c == solcomp.Service_Job__c){
                                //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                                //compParts = true;
                                if(solcomp.Id == parts.FailurepartId__c){
                                    if(solcomp.CampaignPartsPercentage__c == '0' || solcomp.CampaignPartsPercentage__c == null || solcomp.CampaignPartsPercentage__c == ''){
                                        percentageCov = '0';
                                    }
                                    else
                                        percentageCov = '100';
                                    listATCpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.FailurepartId__r.CSS_Account_Formula__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Replacement_Reason__c,parts.Notes__c,partcount,percentageCov));
                                }
                                //system.debug('listpartcampWrapper**'+listpartcampWrapper);
                            }

                            system.debug('listATCpartWrapper**'+listATCpartWrapper);
                        }
                        listATCcompwrapper.add(new compwrapper(solComp.id,solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,listATCpartWrapper,partcount));
                        system.debug('listATCcompwrapper**'+listATCcompwrapper);
                    }                
                }
            }
        }catch(Exception ex){
            System.debug('in catch of ATCPartsData of CSS_Parts_Options__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    public void ResetCTAData() {
        system.debug('Hi.......');
        system.debug('InsideREstAction**');
        // Commented as part of 101 SOQL issue fix 
    campPartlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,Service_Job__c,
                             (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,FailurepartId__r.FailCode_Formula__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                              from CSS_Parts_Options__r) 
                             from CSS_Solution_Component__c where Type__c='Campaign' and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
       TrpPartlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,FailCode_Formula__c,CampaignPartsPercentage__c,Service_Job__c,
                            (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.FailCode_Formula__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                             from CSS_Parts_Options__r) // where Service_Job__c =:Wid
                            from CSS_Solution_Component__c where Type__c='TRP' and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
        
       
       AtcPartlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,Service_Job__c,FailCode_Formula__c,
                            (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.FailCode_Formula__c,FailurepartId__r.AccountCode__c,FailurepartId__r.CSS_Account_Formula__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                             from CSS_Parts_Options__r) 
                            from CSS_Solution_Component__c where Type__c='ATC' and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            
            //Boolean compParts = false;

            integer Compcount = 0;
        system.debug('campPartlstUI>>>+'+campPartlstUI.size());
         system.debug('AtcPartlstUI>>>+'+AtcPartlstUI.size());
        
            if(campPartlstUI!=null){
                 system.debug('campPartlstUIinside>>>+'+campPartlstUI);
                listcompWrapper = new List<compWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : campPartlstUI){
                    system.debug('kkkkkkk');
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        integer partcount = 0;
                        string percentageCov;
                        listPartWrapper = new list<PartWrapper>();
                        system.debug('Outsidepartcount*'+partcount);
                        for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r){
                            partcount = partcount + 1;
                            system.debug('Insidepartcount*'+partcount);
                            if(parts.Service_Job__c == solcomp.Service_Job__c){
                                //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                                //compParts = true;
                                if(solcomp.Id == parts.FailurepartId__c){
                                    if(solcomp.CampaignPartsPercentage__c == '0' || solcomp.CampaignPartsPercentage__c == null || solcomp.CampaignPartsPercentage__c == ''){
                                        percentageCov = '0';
                                    }
                                    else
                                        percentageCov = '100';
                                    listpartWrapper.add(new partWrapper(parts.Id,parts.selected_part__c,solcomp.Component_Id__c,solcomp.Type__c,parts.FailurepartId__r.CSS_Account_Formula__c,String.valueof(parts.Quantity__c),parts.Service_partnumber__c,parts.OEM__c,parts.Part_Name__c,parts.ReturnToFactory__c,solcomp.CampaignPartsPercentage__c,parts.FailurepartId__r.FailCode_Formula__c,parts.Replacement_Reason__c,parts.Notes__c,partcount,percentageCov));
                                }
                                //system.debug('listpartcampWrapper**'+listpartcampWrapper);
                            }

                            system.debug('listpartWrapper**'+listpartWrapper);
                        }
                        listcompwrapper.add(new compwrapper(solComp.id,solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,listpartWrapper,partcount));
                        system.debug('after listcompwrapper>>>:'+listcompwrapper);
                    }                
                }
            }
        system.debug('final listcompWrapper>>:' + listcompWrapper.size());
        getAllTRPPartsData();
        getAllATCPartsData();
        system.debug('Hey.......');
        isReset = true;
    }
    
    public void saveCTAData(){
        AllPartlstUI = new list<CSS_Solution_Component__c>(); 
        List<CSS_Parts_Options__c> partlstcamp = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> partlstTrp = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> partlstAtc = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> allPartsList = new List<CSS_Parts_Options__c>();
        List<CSS_Solution_Component__c> solcomplsttrp = new List<CSS_Solution_Component__c>();
        List<CSS_Solution_Component__c> solcomplstAtc = new List<CSS_Solution_Component__c>();
        system.debug('New List'+partlstcamp.size());

        try{
            system.debug('inside save method');
            system.debug('CampPartsList*'+listpartWrapper);
            system.debug('CampPartsList1**'+listcompwrapper);
            if(listcompwrapper != null && listcompwrapper.size()>0){
                for(CompWrapper CompWrap: listcompwrapper){
                    //if(listpartWrapper != null && listpartWrapper.size()>0){

                    for(PartWrapper partwrap : CompWrap.partWrapper){
                        system.debug('InsideFor*');
                        CSS_Parts_Options__c partscamp = new CSS_Parts_Options__c();
                        partscamp.Id = partwrap.partids;
                        partscamp.selected_part__c = partwrap.selectedComponent;
                        if(partwrap.quantity == '' || partwrap.quantity == null)
                            partwrap.quantity = '0';
                        partscamp.Quantity__c = Decimal.valueOf(partwrap.quantity);
                        system.debug('Quantity-PartNumber'+partwrap.quantity+'-'+partwrap.servicepart);
                        partscamp.Notes__c = partwrap.notes;
                        partscamp.Replacement_Reason__c = partwrap.replacementreason;
                        partscamp.Service_Job__c = Wid;

                        allPartsList.add(partscamp);
                    }
                }
                system.debug('InsideIF*');
                system.debug('solcomplst*'+partlstcamp);
            } 
            //update partlstcamp;
            system.debug('TRPPartsList*'+listTRPpartWrapper);

            if(listTRPcompwrapper != null && listTRPcompwrapper.size()>0){

                for(CompWrapper compwraptrp : listTRPcompwrapper){
                    for(PartWrapper partwraptrp : compwraptrp.partWrapper){
                        system.debug('InsideFor*');
                        CSS_Parts_Options__c partstrp = new CSS_Parts_Options__c();
                        partstrp.Id = partwraptrp.partids;
                        partstrp.selected_part__c = partwraptrp.selectedComponent;
                        if(partwraptrp.quantity == '' || partwraptrp.quantity == null)
                            partwraptrp.quantity = '0';
                        partstrp.Quantity__c = Decimal.valueOf(partwraptrp.quantity);
                        partstrp.Notes__c = partwraptrp.notes;
                        partstrp.Replacement_Reason__c = partwraptrp.replacementreason;
                        partstrp.Service_Job__c = Wid;

                        allPartsList.add(partstrp);
                    }
                }
                system.debug('InsideIF*');
                system.debug('partlstTrp*'+partlstTrp);
            }

            // update solcomplsttrp;
            //update partlstTrp;

            if(listATCcompwrapper != null && listATCcompwrapper.size()>0){
                for(CompWrapper CompWrapAtc: listATCcompwrapper){
                    for(PartWrapper partatcwrap : CompWrapAtc.partwrapper){
                        if(partatcwrap != null){
                            /*CSS_Solution_Component__c sol2 = new CSS_Solution_Component__c();
                        sol2.Id = solatcwrap.ids;
                        sol2.Selected_Component__c = solatcwrap.selectedComponent;
                        sol2.Quantity__c = Decimal.valueOf(solatcwrap.quantity);
                        sol2.Notes__c = solatcwrap.notes;
                        solcomplstAtc.add(sol2);*/
                            CSS_Parts_Options__c partsAtc = new CSS_Parts_Options__c();
                            partsAtc.Id = partatcwrap.partids;
                            partsAtc.selected_part__c = partatcwrap.selectedComponent;
                            if(partatcwrap.quantity == '' || partatcwrap.quantity == null)
                                partatcwrap.quantity = '0';
                            partsAtc.Quantity__c = Decimal.valueOf(partatcwrap.quantity);
                            partsAtc.Notes__c = partatcwrap.notes;
                            partsAtc.Replacement_Reason__c = partatcwrap.replacementreason;
                            partsAtc.Service_Job__c = Wid;

                            allPartsList.add(partsAtc);

                        }
                    }
                }
            }
            // update solcomplstAtc;    
            //update partlstAtc ;
            //allPartsList.addall(partlstcamp);
            //allPartsList.addall(partlstTrp);
            //allPartsList.addall(partlstAtc);
            system.debug('isSavedInitially**'+isSaved);
            system.debug('allPartsList * '+allPartsList);
            if(allPartsList != null && allPartsList.size()>0){
            update allPartsList;
                 isSaved = true;
            system.debug('isSAved***'+isSaved);}
            system.debug('allPartsList * '+allPartsList);
            
            
           /*AllPartlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,CampaignPartsPercentage__c,Service_Job__c,
                             (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                              from CSS_Parts_Options__r) 
                             from CSS_Solution_Component__c where Type__c in ('Campaign','TRP','ATC') and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            getAllCampPartsData();
        getAllTRPPartsData();
        getAllATCPartsData();*/
           
        }catch(exception e){

            system.debug('Entered into catch block of save parts method in css_CampaignController class' );
            system.debug('Campaign Controller Exception --> '+ e.getLineNumber() + ' ' +e.getMessage() );
        }            
        //pageReference returnPage = ApexPages.currentPage(); 
        //return returnPage;
    }

    public List<SelectOption> getreplacementReasonOptions()    
    {    
        try{
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
        }catch(exception e){
            return null;
        }
    } 
    public class CompWrapper
    {
        public Id CompIds {get;set;}
        public string FieldActNum {get;set;}
        public integer partcount{get;set;}
        /*public string compName {get;set;}
        public string solName {get;set;}
        public string solTitle {get;set;}
        public integer count {get;set;}
        //KAL
        public string FailCode {get;set;}
        public string FailCodeEditable {get;set;}
        public string AccountCode {get;set;}
        public string AccountCodeEdit {get;set;}*/

        public list<PartWrapper> partWrapper {get;set;}
        // public CompWrapper(Id CompIds,string compName,string solName,string solTitle,string FailCode,string FailCodeEditable,string AccountCode,string AccountCodeEdit,list<PartWrapper> partWrapper,integer count){
        public CompWrapper(Id CompIds,string FieldActNum,list<PartWrapper> partWrapper,integer partcount){
            this.CompIds= CompIds;
            /*this.compName = compName;
            this.solName=solName;
            this.solTitle=solTitle;
            this.count=count;
            this.FailCode=FailCode;
            this.FailCodeEditable=FailCodeEditable;
            this.AccountCode=AccountCode;
            this.AccountCodeEdit=AccountCodeEdit;*/
            this.FieldActNum = FieldActNum;
            this.partWrapper = partWrapper;
            this.partcount = partcount;

        }
    }
    public class PartWrapper
    {
        public Id partids {get;set;}
        public Boolean selectedComponent {get;set;}
        public String fieldactnum {get;set;}
        public String type {get;set;}
        public String accountcode {get;set;}
        public String quantity {get;set;}
        public String servicepart {get;set;}
        public String oem {get;set;}
        public String partname {get;set;}
        public String returnToFactory {get;set;}
        public String covered {get;set;}
        public String failcode {get;set;}
        public String replacementreason {get;set;}
        public String notes {get;set;}
        public integer partcount{get;set;}
        public String percentage{get;set;}

        
        public PartWrapper(Id partids,Boolean selectedcomponent,String fieldactnum,String type,String accountcode,String quantity,String servicepart,String oem,String partname,String returnToFactory,String covered,String failcode,String replacementreason,String notes,integer partcount,String percentage) {

            //this.ids = ids;
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
            this.covered = covered;
            this.percentage = percentage;
            this.failcode = failcode;
            this.replacementreason = replacementreason;
            this.notes = notes;
            this.partcount = partcount;
           // this.percentage = percentage;

        }
    }
}