/**********************************************************************
Name:CG_CL_RJFieldActionSRTs_RO
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this controller for jobplan Campaign component in SRT chevron on Jobplan page.
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR                    DATE                DETAIL                                 
1.0     - Anirudh Reddy         11/16/2018          INITIAL DEVELOPMENT 
***********************************************************************/
public class CG_CL_RJFieldActionSRTs_RO
{   
    public Id Wid{get; set;}
    public transient list<CSS_SRT__c> campains{get; set;}
    transient list<CSS_Solution_Component__c> AllsrtlstUI;
    //campains
    public transient list<CSS_Solution_Component__c> campsrtlstUI;    
    public transient list<CompWrapper> listcompWrapper {get;set;}
    public transient list<srtWrapper> listsrtWrapper {get;set;}


    public transient list<CompWrapper> addlistcompWrapper {get;set;}
    public transient list<srtWrapper> addlistsrtWrapper {get;set;}

    public transient list<ATCCompWrapper> addlistatcWrapper {get;set;}
    public transient list<ATCsrtWrapper> addatclistsrtWrapper {get;set;}        

    public transient list<TRPCompWrapper> addlisttrpWrapper {get;set;}
    public transient list<TRPsrtWrapper> addtrplistsrtWrapper {get;set;}   
    //TRP  
    public transient list<CSS_Solution_Component__c> trpsrtlstUI;
    public transient list<TRPCompWrapper> listTRPWrapper1 {get;set;}
    public transient list<TRPsrtWrapper> listTRPsrtWrapper1 {get;set;}
    //ATC 
    public transient list<CSS_Solution_Component__c> atcsrtlstUI;
    public transient list<ATCCompWrapper> listATCWrapper {get;set;}
    public transient list<ATCsrtWrapper> listATCsrtWrapper {get;set;}

    public transient Decimal totalCampaignSRT{get;set;}
    public transient Decimal totalATCSRT{get;set;}
    public transient Decimal totalTRPSRT{get;set;}
    public transient Decimal totalCampaignAccessTime{get;set;}
    public transient Decimal totalATCAccessTime{get;set;}
    public transient Decimal totalTRPAccessTime{get;set;}
    public transient List<css_srt__c> additionalSRTList{get;set;}
    public CG_CL_RJFieldActionSRTs_RO()
    {
        additionalSRTList = new List<css_srt__c>();


        Wid=ApexPages.CurrentPage().getParameters().get('Id'); 
        additionalSRTList  = [select name,SRT_ID__c,id,Extended_Hours__c,SRT_Estimate__c,Job_Order__r.Name, Adjustment_Reason__c,SRT_Warrantable__c,Repair_Access_Calculated__c,Account_Code__c,FailCode__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,SRT_Status_Message__c,SRT_Notes__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code__c,Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c
                              from CSS_SRT__C where Job_Order__c=:Wid and Solution_Number__c = null and component_id__c = null and isPopupSRT__c = true];

        getAllCampSrtsData();
        getAllTRPSrtsData();
        getAllATCSrtsData();
    }
    //Method for getting values which job having type is equal to compain in SRT Object
    public void getAllCampSrtsData(){
        campsrtlstUI = new list<CSS_Solution_Component__c>();
        totalCampaignSRT = 0;
        totalCampaignAccessTime = 0;
        try{
            campsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,Service_Job__r.AccessCode__c,Service_Job__r.Equipment_ID__c,
                            (select Id,SRT_ID__c ,Component_Id__c,SRT_Title__c,SRT_Quantity__c,SRT_Access_Code__c,SRT_Time__c,SRT_Time_Formula__c,Additional_SRT_Calculated__c,Access_Code__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                             //Added fields 
                             Access_Code_A__c,Flex_Flag__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Job_Engine_Access_Code__c,FieldAction_Time__c,SRT_AccessiblityCheck__c,IsDuplicateSRT__c,
                             //End added fields
                             SRT_Warrantable__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c,isPerformed__c,srt_category__c,type__c, Extended_Hours__c,SRT_Estimate__c,Assignment__c,Step_Description__c,Step_Id__c from CSS_SRTs__r where (Assignment__c != 'NOT CLAIMABLE' AND Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED') and Type__c!='99Time' order by CSS_AssignmentOrder__c,SRT_ID__c asc) 
                            from CSS_Solution_Component__c where Type__c='Campaign' and Service_Job__c =:Wid 
                            and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                           and Multiple_Times__c=false))];

            transient integer Compcount = 0;
            system.debug('campsrtlstUI'+campsrtlstUI);
            if(campsrtlstUI!=null){
                listcompWrapper = new List<compWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : campsrtlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        transient integer srtcount = 0;
                        string percentageCov;
                        boolean isPerformedAccessChk;
                        listsrtWrapper = new list<srtWrapper>();
                        system.debug('Outsidepartcount*'+srtcount);
                        system.debug('solcomp.CSS_SRTs__r size>:*'+solcomp.CSS_SRTs__r.size()+' solcomp.CSS_SRTs__r>:'+solcomp.CSS_SRTs__r);
                        for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                            srtcount = srtcount + 1;
                            system.debug('Insidepartcount*'+srtcount);
                            if(srts.Job_Order__c == solcomp.Service_Job__c){
                                //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                                //compParts = true;
                                if(solcomp.Id == srts.Component_Id__c){                                    
                                    percentageCov = '100';
                                    system.debug('srts.type__c'+srts.type__c);
                                    system.debug('srts.SRT_AccessiblityCheck__c'+srts.SRT_AccessiblityCheck__c);
                                    
                                    if(srts.type__c=='Field Action Access'){
                                        isPerformedAccessChk=srts.SRT_AccessiblityCheck__c;
                                    }
                                    else{
                                        isPerformedAccessChk=srts.isPerformed__c;
                                    }
                                    system.debug('isPerformedAccessChk'+isPerformedAccessChk);
                                    listsrtWrapper.add(new srtWrapper(srts.Id,
                                                                      srts.SRT_ID__c,
                                                                      srts.SRT_Title__c,
                                                                      srts.SRT_Quantity__c,
                                                                      String.valueof(srts.Additional_SRT_Calculated__c),
                                                                      srts.SRT_Time__c,
                                                                      srts.Access_Code__c,
                                                                      srts.SRT_Warrantable__c,
                                                                      srts.Adjustment_Reason__c,
                                                                      //srts.SRT_Select__c,
                                                                      isPerformedAccessChk,
                                                                      srts.SRT_Estimate__c,
                                                                      srtcount,
                                                                      percentageCov,
                                                                      srts.type__c,
                                                                      String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0))));
                                }                                
                            }

                            system.debug('listsrtWrapper**'+listsrtWrapper);
                            //if(srts.SRT_Select__c ==true){
                            if(srts.isPerformed__c==true){
                                if(srts.type__c != 'Field Action Access')
                                    totalCampaignSRT = totalCampaignSRT+srts.SRT_Time__c;
                                if(srts.type__c == 'Field Action Access')
                                    totalCampaignAccessTime = totalCampaignAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                            }
                        }
                        listcompWrapper.add(new compwrapper(solComp.id,
                                                            solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,
                                                            listsrtWrapper,srtcount));
                        system.debug('listcompwrapper**'+listcompwrapper);

                    }                
                }
            }

            addlistcompWrapper = new List<compWrapper>();
            ///Compcount = Compcount + 1;
            if(additionalSRTList != null && additionalSRTList.size()>0){
                transient integer srtcount1 = 0;
                transient string percentageCov1;
                boolean isPerformedAccessChk;
                addlistsrtWrapper = new list<srtWrapper>();
                system.debug('Outsidepartcount*'+srtcount1);
                for(CSS_SRT__c srts : additionalSRTList){
                    srtcount1 = srtcount1 + 1;
                    system.debug('Insidepartcount*'+srtcount1);
                    if(srts.srt_category__c == 'Campaign'){
                        // if(srts.Job_Order__c == solcomp.Service_Job__c){
                        //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                        //compParts = true;
                        //if(solcomp.Id == srts.Component_Id__c){                                    
                        percentageCov1 = '100';
                        if(srts.type__c=='Access'){
                            isPerformedAccessChk=srts.SRT_AccessiblityCheck__c;
                        }
                        else{
                            isPerformedAccessChk=srts.isPerformed__c;
                        } 
                        addlistsrtWrapper.add(new srtWrapper(srts.Id,
                                                             srts.SRT_ID__c,
                                                             srts.SRT_Title__c,
                                                             srts.SRT_Quantity__c,
                                                             String.valueof(srts.Additional_SRT_Calculated__c),
                                                             srts.SRT_Time__c,
                                                             srts.Access_Code__c,
                                                             srts.SRT_Warrantable__c,
                                                             srts.Adjustment_Reason__c,
                                                             //srts.SRT_Select__c,
                                                             isPerformedAccessChk,
                                                             srts.SRT_Estimate__c,
                                                             srtcount1,
                                                             percentageCov1,
                                                             srts.type__c,
                                                             String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0))));

                        // }

                        system.debug('addlistsrtWrapper**'+addlistsrtWrapper);
                        //if(srts.SRT_Select__c ==true){
                        if(srts.isPerformed__c==true){
                            if(srts.type__c != 'Field Action Access')
                                totalCampaignSRT = totalCampaignSRT+srts.SRT_Time__c;
                            if(srts.type__c == 'Field Action Access')
                                totalCampaignAccessTime = totalCampaignAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                        }
                    }
                }
                addlistcompWrapper.add(new compwrapper(null,
                                                       'Additional SRTs',
                                                       addlistsrtWrapper,srtcount1));
                system.debug('addlistcompwrapper**'+addlistcompwrapper);

            }                

        }
        catch(Exception ex){
            System.debug('in catch of CampSrtsData of CSS_SRT__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //Method for getting values which job having type is equal to TRP in SRT Object
    public void getAllTRPSrtsData(){
        TrpsrtlstUI = new list<CSS_Solution_Component__c>();
        totalTRPSRT = 0;
        totalTRPAccessTime = 0;
        try{
            system.debug('JobID>>>>>>>>>campParts>:'+Wid);
            TrpsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,
                           (select Id,SRT_ID__c ,Component_Id__c,SRT_Title__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_Time__c,Access_Code__c,
                            SRT_Warrantable__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c,isPerformed__c,type__c,Extended_Hours__c,SRT_Estimate__c from CSS_SRTs__r) 
                           from CSS_Solution_Component__c where Type__c='TRP' and Service_Job__c =:Wid 
                           and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                                                                                                                                                    and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            transient integer Compcount = 0;
            if(TrpsrtlstUI!=null){
                //listtrpWrapper = new List<compWrapper>();
                listtrpwrapper1 = new List<trpcompwrapper>();
                //  CompCountVar = false;
                system.debug('TrpsrtlstUI:'+TrpsrtlstUI);
                for(CSS_Solution_Component__c solcomp : TrpsrtlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        transient integer trpsrtcount = 0;
                        transient string percentageCov;
                          Boolean isPerformedAccessChk;
                        listTRPsrtWrapper1 = new list<trpsrtWrapper>();
                        system.debug('Outsidepartcount*'+trpsrtcount);
                        system.debug('Value:-'+solcomp.CSS_SRTs__r);
                        for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                            // trpsrtcount = trpsrtcount + 1;
                            system.debug('Insidepartcount*'+trpsrtcount);
                            if(srts.Job_Order__c == solcomp.Service_Job__c){
                                if(solcomp.Id == srts.Component_Id__c){                                    
                                    percentageCov = '100';
                                    trpsrtcount = trpsrtcount + 1;
                                     if(srts.type__c=='Field Action Access'){
                                        isPerformedAccessChk=srts.SRT_AccessiblityCheck__c;
                                    }
                                    else{
                                        isPerformedAccessChk=srts.isPerformed__c;
                                    }
                                    listTRPsrtWrapper1.add(new trpsrtWrapper(srts.Id,
                                                                             srts.SRT_ID__c,
                                                                             srts.SRT_Title__c,
                                                                             srts.SRT_Quantity__c,
                                                                             String.valueof(srts.Additional_SRT_Calculated__c),
                                                                             srts.SRT_Time__c,
                                                                             srts.Access_Code__c,
                                                                             srts.SRT_Warrantable__c,
                                                                             srts.Adjustment_Reason__c,
                                                                             //srts.SRT_Select__c,
                                                                             isPerformedAccessChk,
                                                                             srts.SRT_Estimate__c,
                                                                             trpsrtcount,
                                                                             percentageCov,
                                                                             srts.type__c,
                                                                             String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0))));
                                }                                
                            }

                            system.debug('listTRPsrtWrapper**'+listTRPsrtWrapper1);
                            //if(srts.SRT_Select__c ==true){
                            if(srts.isPerformed__c==true){
                                if(srts.type__c != 'Field Action Access')
                                    totalTRPSRT = totalTRPSRT+ (srts.SRT_Time__c * srts.SRT_Quantity__c);
                                if(srts.type__c == 'Field Action Access')
                                    totalTRPAccessTime = totalTRPAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                            }
                        }
                        listtrpwrapper1.add(new TRPCompWrapper(solComp.id,
                                                               solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,
                                                               listtrpsrtWrapper1,
                                                               trpsrtcount));
                        system.debug('listtrpwrapper**'+listtrpwrapper1);
                    }                
                }
            }
            addlisttrpWrapper = new List<TRPCompWrapper>();
            ///Compcount = Compcount + 1;
            if(additionalSRTList != null && additionalSRTList.size()>0){
                transient integer srtcount1 = 0;
                transient string percentageCov1;
                  Boolean isPerformedAccessChk;
                addtrplistsrtWrapper = new list<TRPsrtWrapper>();
                system.debug('Outsidepartcount*'+srtcount1);
                for(CSS_SRT__c srts : additionalSRTList){
                    srtcount1 = srtcount1 + 1;
                    system.debug('Insidepartcount*'+srtcount1);
                    if(srts.srt_category__c == 'TRP'){
                        // if(srts.Job_Order__c == solcomp.Service_Job__c){
                        //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                        //compParts = true;
                        //if(solcomp.Id == srts.Component_Id__c){                                    
                        percentageCov1 = '100';
                         if(srts.type__c=='Access'){
                            isPerformedAccessChk=srts.SRT_AccessiblityCheck__c;
                        }
                        else{
                            isPerformedAccessChk=srts.isPerformed__c;
                        }

                        addtrplistsrtWrapper.add(new TRPsrtWrapper(srts.Id,
                                                                   srts.SRT_ID__c,
                                                                   srts.SRT_Title__c,
                                                                   srts.SRT_Quantity__c,
                                                                   String.valueof(srts.Additional_SRT_Calculated__c),
                                                                   srts.SRT_Time__c,
                                                                   srts.Access_Code__c,
                                                                   srts.SRT_Warrantable__c,
                                                                   srts.Adjustment_Reason__c,
                                                                   //srts.SRT_Select__c,
                                                                   isPerformedAccessChk,
                                                                   srts.SRT_Estimate__c,
                                                                   srtcount1,
                                                                   percentageCov1,
                                                                   srts.type__c,
                                                                   String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0))));

                        // }

                        system.debug('addtrplistsrtWrapper**'+addtrplistsrtWrapper);
                        //if(srts.SRT_Select__c ==true){
                        if(srts.isPerformed__c==true){
                            if(srts.type__c != 'Field Action Access')
                                totalCampaignSRT = totalCampaignSRT+srts.SRT_Time__c;
                            if(srts.type__c == 'Field Action Access')
                                totalCampaignAccessTime = totalCampaignAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                        }
                    }
                }
                addlisttrpWrapper.add(new TRPCompWrapper(null,
                                                         'Additional SRTs',
                                                         addtrplistsrtWrapper,srtcount1));
                system.debug('addlisttrpWrapper**'+addlisttrpWrapper);

            }                

        }
        catch(Exception ex){
            System.debug('in catch of CampSrtsData of CSS_SRT__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //Method for getting values which job having type is equal to ATC in SRT Object
    public void getAllATCSrtsData(){
        atcsrtlstUI = new list<CSS_Solution_Component__c>();
        totalATCSRT=0;
        totalATCAccessTime=0;
        try{
            system.debug('JobID>>>>>>>>>campParts>:'+Wid);
            atcsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,
                           (select Id,SRT_ID__c ,Component_Id__c,SRT_Title__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_Time__c,Access_Code__c,
                            SRT_Warrantable__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c,isPerformed__c,type__c,Extended_Hours__c,SRT_Estimate__c from CSS_SRTs__r) 
                           from CSS_Solution_Component__c where Type__c='ATC' and Service_Job__c =:Wid 
                           and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                           and Multiple_Times__c=false))];
            system.debug('****atcsrtlstUI****'+atcsrtlstUI);
            transient integer Compcount = 0;
            if(atcsrtlstUI!=null){
                listatcWrapper = new List<ATCCompWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : atcsrtlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        transient integer atcsrtcount = 0;
                        transient string percentageCov = '100';
                        Boolean isPerformedAccessChk;
                        listatcsrtWrapper = new list<atcsrtWrapper>();
                        system.debug('Outsidepartcount*'+atcsrtcount);
                        for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                            atcsrtcount = atcsrtcount + 1;
                            system.debug('Insidepartcount*'+atcsrtcount);
                            if(srts.Job_Order__c == solcomp.Service_Job__c){
                                if(solcomp.Id == srts.Component_Id__c){                                    
                                    //percentageCov = '100'; 
                                    /*if(srts.SRT_Hours_Percentage__c==null && srts.SRT_Hours_Percentage__c==0)                                  
                                    percentageCov ='100';
                                else  
                                    percentageCov = String.valueof(srts.SRT_Hours_Percentage__c);*/
                                    percentageCov = srts.SRT_Warrantable__c;
                                      if(srts.type__c=='Field Action Access'){
                                        isPerformedAccessChk=srts.SRT_AccessiblityCheck__c;
                                    }
                                    else{
                                        isPerformedAccessChk=srts.isPerformed__c;
                                    }

                                    listatcsrtWrapper.add(new atcsrtWrapper(srts.Id,
                                                                            srts.SRT_ID__c,
                                                                            srts.SRT_Title__c,
                                                                            srts.SRT_Quantity__c,
                                                                            String.valueof(srts.Additional_SRT_Calculated__c),
                                                                            srts.SRT_Time__c,
                                                                            srts.Access_Code__c,
                                                                            percentageCov,
                                                                            srts.Adjustment_Reason__c,
                                                                            //srts.SRT_Select__c,
                                                                            isPerformedAccessChk,
                                                                            srts.SRT_Estimate__c,
                                                                            atcsrtcount,
                                                                            percentageCov,
                                                                            srts.type__c,
                                                                            String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0))));
                                }                                
                            }

                            system.debug('listatcsrtWrapper**'+listatcsrtWrapper);
                            //if(srts.SRT_Select__c ==true){
                            if(srts.isPerformed__c==true){
                                if(srts.type__c != 'Field Action Access')
                                    totalATCSRT = totalATCSRT+(srts.SRT_Time__c * srts.SRT_Quantity__c);
                                if(srts.type__c == 'Field Action Access')
                                    totalATCAccessTime = totalATCAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                            }
                        }
                        listatcwrapper.add(new ATCCompWrapper(solComp.id,
                                                              solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,
                                                              listatcsrtWrapper,
                                                              atcsrtcount));
                        system.debug('listatcwrapper**'+listatcwrapper);
                    }                
                }
            }
            addlistatcWrapper = new List<ATCcompWrapper>();
            ///Compcount = Compcount + 1;
            if(additionalSRTList != null && additionalSRTList.size()>0){
                transient integer srtcount1 = 0;
                transient string percentageCov1;
                 Boolean isPerformedAccessChk;
                addatclistsrtWrapper = new list<atcsrtWrapper>();
                system.debug('Outsidepartcount*'+srtcount1);
                for(CSS_SRT__c srts : additionalSRTList){
                    srtcount1 = srtcount1 + 1;
                    system.debug('Insidepartcount*'+srtcount1);
                    if(srts.srt_category__c == 'ATC'){
                        // if(srts.Job_Order__c == solcomp.Service_Job__c){
                        //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                        //compParts = true;
                        //if(solcomp.Id == srts.Component_Id__c){                                    
                        percentageCov1 = '100';
                        if(srts.type__c=='Access'){
                            isPerformedAccessChk=srts.SRT_AccessiblityCheck__c;
                        }
                        else{
                            isPerformedAccessChk=srts.isPerformed__c;
                        }
                        addatclistsrtWrapper.add(new atcsrtWrapper(srts.Id,
                                                                   srts.SRT_ID__c,
                                                                   srts.SRT_Title__c,
                                                                   srts.SRT_Quantity__c,
                                                                   String.valueof(srts.Additional_SRT_Calculated__c),
                                                                   srts.SRT_Time__c,
                                                                   srts.Access_Code__c,
                                                                   srts.SRT_Warrantable__c,
                                                                   srts.Adjustment_Reason__c,
                                                                   //srts.SRT_Select__c,
                                                                   isPerformedAccessChk,
                                                                   srts.SRT_Estimate__c,
                                                                   srtcount1,
                                                                   percentageCov1,
                                                                   srts.type__c,
                                                                   String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0))));

                        // }

                        system.debug('addatclistsrtWrapper**'+addatclistsrtWrapper);
                        //if(srts.SRT_Select__c ==true){
                        if(srts.isPerformed__c==true){
                            if(srts.type__c != 'Field Action Access')
                                totalCampaignSRT = totalCampaignSRT+srts.SRT_Time__c;
                            if(srts.type__c == 'Field Action Access')
                                totalCampaignAccessTime = totalCampaignAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                        }
                    }
                }
                addlistatcWrapper.add(new ATCcompWrapper(null,
                                                         'Additional SRTs',
                                                         addatclistsrtWrapper,srtcount1));
                system.debug('addlistatcWrapper**'+addlistatcWrapper);

            }                




        }
        catch(Exception ex){
            System.debug('in catch of AtcSrtsData of CSS_SRT__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }

    //This method is called on TND and Repair Review job pages.
    public PageReference gotoJobPlanSrt(){       
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanSRT?id='+Wid); 
        pageRef.setRedirect(true);
        return pageRef;
    }

    //wrapper classes for COMPONENT and SRT when type is equal to CAMPAIGN
    public class CompWrapper{
        public transient Id CompIds {get;set;}
        public transient string FieldActNum {get;set;}
        public transient list<srtWrapper> srtWrapper {get;set;}
        public transient integer srtcount{get;set;}
        public CompWrapper(Id CompIds,string FieldActNum,list<srtWrapper> srtWrapper,integer srtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.srtWrapper = srtWrapper;
            this.srtcount = srtcount;
        }
    }    
    public class srtWrapper{
        public transient Id srtids {get;set;}
        public transient String SRTCode  {get;set;} 
        public transient String SRTDescription  {get;set;}
        public transient Decimal quantity {get;set;} 
        public transient String ACCESSSRTTime {get;set;} 
        public transient Decimal SRTTime {get;set;} 
        public transient String AccessCode {get;set;} 
        public transient String SRTHours {get;set;}
        public transient String AdjustmentReason  {get;set;}
        public transient Boolean selectedComponent {get;set;}
        public transient Boolean estimate {get;set;} 
        public transient integer srtcount{get;set;}
        public transient String percentage{get;set;} 
        public transient String type{get;set;}
        public transient String extendedHours{get;set;}

        public srtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedComponent,Boolean estimate,integer srtcount,String percentage,String type,String extendedHours) {

            this.srtids = srtids;
            this.SRTCode = SRTCode;
            this.SRTDescription = SRTDescription;
            this.quantity = quantity;
            this.ACCESSSRTTime = ACCESSSRTTime;
            this.SRTTime = SRTTime;
            this.AccessCode = AccessCode;
            this.SRTHours = SRTHours;
            this.AdjustmentReason = AdjustmentReason;
            this.selectedComponent = selectedcomponent;
            this.estimate = estimate;
            this.srtcount = srtcount;
            this.percentage = percentage;
            this.type = type;
            this.extendedHours = extendedHours;
        }       
    }
    //wrapper classes for COMPONENT and SRT when type is equal to TRP
    public class TRPsrtWrapper{
        public transient Id srtids {get;set;}
        public transient String SRTCode  {get;set;} 
        public transient String SRTDescription  {get;set;}
        public transient Decimal quantity {get;set;} 
        public transient String ACCESSSRTTime {get;set;} 
        public transient Decimal SRTTime {get;set;} 
        public transient String AccessCode {get;set;} 
        public transient String SRTHours {get;set;}
        public transient String AdjustmentReason  {get;set;}
        public transient Boolean selectedComponent {get;set;} 
        public transient Boolean estimate {get;set;}
        public transient integer trpsrtcount{get;set;}
        public transient String percentage{get;set;} 
        public transient String type{get;set;}
        public transient String extendedHours{get;set;}


        public TRPsrtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedcomponent,Boolean estimate,integer trpsrtcount,String percentage,String type,String extendedHours) {

            this.srtids = srtids;
            this.SRTCode = SRTCode;
            this.SRTDescription = SRTDescription;
            this.quantity = quantity;
            this.ACCESSSRTTime = ACCESSSRTTime;
            this.SRTTime = SRTTime;
            this.AccessCode = AccessCode;
            this.SRTHours = SRTHours;
            this.AdjustmentReason = AdjustmentReason;
            this.selectedComponent = selectedcomponent;
            this.estimate = estimate;
            this.trpsrtcount = trpsrtcount;
            this.percentage = percentage;
            this.type = type;
            this.extendedHours = extendedHours;

        }

    }
    public class TRPCompWrapper{
        public transient Id CompIds {get;set;}
        public transient string FieldActNum {get;set;}
        public transient list<TRPsrtWrapper> TRPsrtWrapper {get;set;}
        public transient integer trpsrtcount{get;set;}
        public TRPCompWrapper(Id CompIds,string FieldActNum,list<TRPsrtWrapper> TRPsrtWrapper,integer trpsrtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.TRPsrtWrapper = TRPsrtWrapper;
            this.trpsrtcount = trpsrtcount;
        }
    }
    //wrapper classes for COMPONENT and SRT when type is equal to ATC
    public class ATCsrtWrapper{
        public transient Id srtids {get;set;}
        public transient String SRTCode  {get;set;} 
        public transient String SRTDescription  {get;set;}
        public transient Decimal quantity {get;set;} 
        public transient String ACCESSSRTTime {get;set;} 
        public transient Decimal SRTTime {get;set;} 
        public transient String AccessCode {get;set;} 
        public transient String SRTHours {get;set;}
        public transient String AdjustmentReason  {get;set;}
        public transient Boolean selectedComponent {get;set;} 
        public transient Boolean estimate {get;set;}
        public transient integer atcsrtcount{get;set;}
        public transient String percentage{get;set;} 
        public transient String type{get;set;} 
        public transient String extendedHours{get;set;}

        public ATCsrtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedcomponent,Boolean estimate,integer atcsrtcount,String percentage,String type,String extendedHours) {

            this.srtids = srtids;
            this.SRTCode = SRTCode;
            this.SRTDescription = SRTDescription;
            this.quantity = quantity;
            this.ACCESSSRTTime = ACCESSSRTTime;
            this.SRTTime = SRTTime;
            this.AccessCode = AccessCode;

            this.SRTHours = SRTHours; 

            this.AdjustmentReason = AdjustmentReason;
            this.selectedComponent = selectedcomponent;
            this.estimate = estimate;
            this.atcsrtcount = atcsrtcount;
            this.percentage = percentage;
            this.type = type;
            this.extendedHours = extendedHours;

        }

    }
    public class ATCCompWrapper{
        public transient Id CompIds {get;set;}
        public transient string FieldActNum {get;set;}
        public transient list<ATCsrtWrapper> ATCsrtWrapper {get;set;}
        public transient integer atcsrtcount{get;set;}
        public ATCCompWrapper(Id CompIds,string FieldActNum,list<ATCsrtWrapper> ATCsrtWrapper,integer atcsrtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.ATCsrtWrapper = ATCsrtWrapper;
            this.atcsrtcount = atcsrtcount;
        }
    }

}