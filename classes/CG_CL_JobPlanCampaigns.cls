/**********************************************************************
Name:CG_CL_JobPlanCampaigns
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
1.0     - Rajesh Pasupuleti         02/09/2018          INITIAL DEVELOPMENT 
***********************************************************************/
public class CG_CL_JobPlanCampaigns
{   
    public Id Wid{get; set;}
    public list<CSS_SRT__c> campains{get; set;}
    list<CSS_Solution_Component__c> AllsrtlstUI;
    //campains
    public list<CSS_Solution_Component__c> campsrtlstUI;    
    public list<CompWrapper> listcompWrapper {get;set;}
    public list<srtWrapper> listsrtWrapper {get;set;}
    public map<id,list<selectoption>> mapaccesscode{get;set;}//Added as part of the story#172627

    public list<CompWrapper> addlistcompWrapper {get;set;}
    public list<srtWrapper> addlistsrtWrapper {get;set;}

    public list<ATCCompWrapper> addlistatcWrapper {get;set;}
    public list<ATCsrtWrapper> addatclistsrtWrapper {get;set;}        

    public list<TRPCompWrapper> addlisttrpWrapper {get;set;}
    public list<TRPsrtWrapper> addtrplistsrtWrapper {get;set;}   
    //TRP  
    public list<CSS_Solution_Component__c> trpsrtlstUI;
    public list<TRPCompWrapper> listTRPWrapper1 {get;set;}
    public list<TRPsrtWrapper> listTRPsrtWrapper1 {get;set;}
    //ATC 
    public list<CSS_Solution_Component__c> atcsrtlstUI;
    public list<ATCCompWrapper> listATCWrapper {get;set;}
    public list<ATCsrtWrapper> listATCsrtWrapper {get;set;}

    public  Boolean isSaved {get;set;}
    public  Boolean isReset {get;set;}
    public Decimal totalCampaignSRT{get;set;}
    public Decimal totalATCSRT{get;set;}
    public Decimal totalTRPSRT{get;set;}
    public Decimal totalCampaignAccessTime{get;set;}
    public Decimal totalATCAccessTime{get;set;}
    public Decimal totalTRPAccessTime{get;set;}
    public List<css_srt__c> additionalSRTList{get;set;}
    public String EquipIdFA {get;set;}
    public CG_CL_JobPlanCampaigns()
    {
        additionalSRTList = new List<css_srt__c>();


        Wid=ApexPages.CurrentPage().getParameters().get('Id'); 
        system.debug('inside constructor'+Wid);
        additionalSRTList  = [select name,SRT_ID__c,id,SRT_Access_Code__c,IsDuplicateSRT__c,Step_Description__c,Extended_Hours__c,SRT_Estimate__c,Job_Order__r.Name, Adjustment_Reason__c,Repair_Access_Calculated__c,Account_Code__c,FailCode__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code__c,Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,
                              Access_Code_A__c,Access_Code_B__c,SRT_Time_Formula__c,Flex_Flag__c,FieldAction_Time__c,Assignment__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c from CSS_SRT__C where Job_Order__c=:Wid and Solution_Number__c = null and component_id__c = null and isPopupSRT__c = true];
        system.debug('additionalSRTList**'+additionalSRTList);
        isSaved = false;
        isReset = false;

        mapaccesscode = new map<id,list<selectoption>>();
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
            system.debug('JobID>>>>>>>>>campParts>:'+Wid);
            campsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,Service_Job__r.AccessCode__c,Service_Job__r.Equipment_ID__c,
                            (select Id,SRT_ID__c ,Component_Id__c,SRT_Title__c,SRT_Quantity__c,SRT_Access_Code__c,SRT_Time__c,SRT_Time_Formula__c,Additional_SRT_Calculated__c,Access_Code__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                             //Added fields 
                             Access_Code_A__c,Flex_Flag__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Job_Engine_Access_Code__c,FieldAction_Time__c,SRT_AccessiblityCheck__c,IsDuplicateSRT__c,
                             //End added fields
                             SRT_Warrantable__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c,isPerformed__c,srt_category__c,type__c, Extended_Hours__c,SRT_Estimate__c,Assignment__c,Step_Description__c,Step_Id__c from CSS_SRTs__r where (Assignment__c != 'NOT CLAIMABLE' AND Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED') and Type__c!='99Time' order by CSS_AssignmentOrder__c,SRT_ID__c asc) 
                            from CSS_Solution_Component__c where Type__c='Campaign' and Service_Job__c =:Wid 
                            and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                           and Multiple_Times__c=false))];
            system.debug('*****camplst***'+campsrtlstUI);
           /* if(campsrtlstUI!=null && campsrtlstUI.size()>0)
            EquipIdFA = campsrtlstUI[0].Service_Job__r.Equipment_ID__c; // Story GSSC-20*/

            integer Compcount = 0;
            if(campsrtlstUI!=null){
                listcompWrapper = new List<compWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : campsrtlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        integer srtcount = 0;
                        string percentageCov;
                        string addAccesscode;
                        Boolean isPerformedAccessChk;
                        listsrtWrapper = new list<srtWrapper>();
                        system.debug('Outsidepartcount*'+srtcount);
                        system.debug('solcomp.CSS_SRTs__r size>:*'+solcomp.CSS_SRTs__r.size()+' solcomp.CSS_SRTs__r>:'+solcomp.CSS_SRTs__r);
                        for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                            srtcount = srtcount + 1;
                            //Below code added for the story#172627
                            if(!mapaccesscode.containsKey(srts.id))
                                mapaccesscode.put(srts.id,new list<selectoption>());
                            system.debug('Insidepartcount*'+srtcount);
                            if(srts.Job_Order__c == solcomp.Service_Job__c){
                                //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                                //compParts = true;
                                if(solcomp.Id == srts.Component_Id__c){   
                                    system.debug('SRTID*Kal**'+srts.SRT_ID__c);
                                    system.debug('SRTID*Kal**'+srts.Job_Engine_Access_Code__c);
                                    system.debug('SRTID*Kal**'+srts.Access_Code__c);
                                    system.debug('SRTID*Kal**'+srts.SRT_Access_Code__c);
                                    percentageCov = '100';
                                    If( srts.Job_Engine_Access_Code__c!=null && srts.Job_Engine_Access_Code__c!='R' && (srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 ) && srts.Access_Code_R__c!=0)
                                        addAccesscode = 'R';//addAccessCode used in the front end display condition .
                                    else
                                        addAccesscode = srts.Job_Engine_Access_Code__c;
                                    system.debug('addAccesscode**'+addAccesscode);
                                    //Below code added for the story172627
                                    //Below if condition for setting up default value.
                                    if(srts.Access_Code__c=='' || srts.Access_Code__c==null || string.isBlank(srts.Access_Code__c))
                                    {
                                        srts.Access_Code__c=srts.SRT_Access_Code__c;
                                    }

                                    CG_UtilityForSRT srtcampaign = new CG_UtilityForSRT();
                                    list<selectoption> Accesscodetemp=srtcampaign.getAccesscodejoboption(string.valueOf(srts.Access_Code_A__c),string.valueOf(srts.Access_Code_B__c),string.valueOf(srts.Access_Code_C__c),string.valueOf(srts.Access_Code_D__c),string.valueOf(srts.Access_Code_R__c),solcomp.Service_Job__r.AccessCode__c,srts.SRT_Access_Code__c, 'RepairOrFA');
                                    if(Accesscodetemp.size()>0)
                                        mapaccesscode.put(srts.id, Accesscodetemp);
                                    //end
                                    //Added as part of story 177350 -kung fu panda sprint
                                    // srts.isPerformed__c = (srts.Assignment__c!=null && srts.Assignment__c=='PRIMARY');

                                    System.debug('srts.Access_Code_Flag__c>:'+srts.Access_Code_Flag__c+' srts.SRT_Warrantable_Flag>:'+srts.SRT_Warrantable_Flag__c+' srts.Id>:'+srts.Id+' srts.SRT_ID__c>:'+srts.SRT_ID__c);

                                    if(srts.type__c=='Field Action Access'){
                                        isPerformedAccessChk=srts.SRT_AccessiblityCheck__c;
                                    }
                                    else{
                                        isPerformedAccessChk=srts.isPerformed__c;
                                    }
                                     system.debug('listsrtWrappekkkr**'+listsrtWrapper);
                                    listsrtWrapper.add(new srtWrapper(srts.Id,
                                                                      srts.SRT_ID__c,
                                                                      srts.SRT_Title__c,
                                                                      srts.SRT_Quantity__c,
                                                                      String.valueof(srts.Additional_SRT_Calculated__c),
                                                                      srts.SRT_Time_Formula__c, //this stmnt formula works for all
                                                                      srts.Access_Code__c,
                                                                      srts.SRT_Warrantable__c,
                                                                      srts.Adjustment_Reason__c,
                                                                      //srts.SRT_Select__c,
                                                                      isPerformedAccessChk,
                                                                      srts.SRT_Estimate__c,
                                                                      srtcount,
                                                                      percentageCov,
                                                                      srts.type__c,
                                                                      String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0)),
                                                                      addAccesscode,
                                                                      String.valueof(srts.Access_Code_A__c),
                                                                      String.valueof(srts.Access_Code_B__c),
                                                                      String.valueof(srts.Access_Code_C__c),
                                                                      String.valueof(srts.Access_Code_D__c),
                                                                      String.valueof(srts.Access_Code_R__c),
                                                                      srts.Access_Code_Flag__c,
                                                                      srts.SRT_Warrantable_Flag__c,
                                                                      srts.Step_Id__c,
                                                                      srts.Step_Description__c,
                                                                      srts.SRT_Category__c,
                                                                      srts.Flex_Flag__c
                                                                     ));
                                    //srts.Job_Engine_Access_Code__c));
                                }                                
                            }
                            system.debug('listsrtWrapper**'+listsrtWrapper);

                            //if(srts.SRT_Select__c ==true){
                            if(srts.isPerformed__c==true){
                                if(srts.type__c != 'Field Action Access')
                                    totalCampaignSRT = totalCampaignSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);

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
                integer srtcount1 = 0;
                string percentageCov1;
                string addAccesscode;
                Boolean isPerformedAccessChk;
                addlistsrtWrapper = new list<srtWrapper>();
                system.debug('Outsidepartcount*'+srtcount1);
                for(CSS_SRT__c srts : additionalSRTList){
                    system.debug('additionalSRTList SRT>:*'+srts);
                    srtcount1 = srtcount1 + 1;
                    //Below code added for the story#172627
                    if(!mapaccesscode.containsKey(srts.id))
                        mapaccesscode.put(srts.id,new list<selectoption>());
                    system.debug('Insidepartcount*'+srtcount1);
                    if(srts.srt_category__c == 'Campaign'){
                        // if(srts.Job_Order__c == solcomp.Service_Job__c){
                        //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                        //compParts = true;
                        //if(solcomp.Id == srts.Component_Id__c){                                    
                        percentageCov1 = '100';

                        If( srts.Job_Engine_Access_Code__c!=null && srts.Job_Engine_Access_Code__c!='R' && (srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 ) && srts.Access_Code_R__c!=0)
                            addAccesscode = 'R';
                        else
                            addAccesscode = srts.Job_Engine_Access_Code__c;

                        //Below code added for the story172627
                        if(srts.Access_Code__c==null || srts.Access_Code__c=='' || string.isBlank(srts.Access_Code__c))
                        {
                            if( srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 && srts.Access_Code_R__c!=0)
                            {
                                srts.Access_Code__c='R';
                                srts.SRT_Access_Code__c='R';
                            }
                            else
                            {
                                srts.Access_Code__c=srts.Job_Engine_Access_Code__c;
                                srts.SRT_Access_Code__c=srts.Job_Engine_Access_Code__c;
                            }
                        }
                        CG_UtilityForSRT srtTRP = new CG_UtilityForSRT();
                        list<selectoption> Accesscodetemp =srtTRP.getAccesscodejoboption(string.valueOf(srts.Access_Code_A__c),string.valueOf(srts.Access_Code_B__c),string.valueOf(srts.Access_Code_C__c),string.valueOf(srts.Access_Code_D__c),string.valueOf(srts.Access_Code_R__c),srts.Job_Order__r.AccessCode__c,srts.SRT_Access_Code__c, 'RepairOrFA');

                        if(Accesscodetemp.size()>0)
                            mapaccesscode.put(srts.id, Accesscodetemp);
                        //end
                        //Added as part of story 177350 -kung fu panda sprint
                        // srts.isPerformed__c = (srts.Assignment__c!=null && srts.Assignment__c=='PRIMARY'); 

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
                                                             srts.SRT_Time_Formula__c, //this stmnt formula works for all
                                                             srts.Access_Code__c,
                                                             srts.SRT_Warrantable__c,
                                                             srts.Adjustment_Reason__c,
                                                             //srts.SRT_Select__c,
                                                             isPerformedAccessChk,
                                                             srts.SRT_Estimate__c,
                                                             srtcount1,
                                                             percentageCov1,
                                                             srts.type__c,
                                                             String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0)),
                                                             addAccesscode,
                                                             String.valueof(srts.Access_Code_A__c),
                                                             String.valueof(srts.Access_Code_B__c),
                                                             String.valueof(srts.Access_Code_C__c),
                                                             String.valueof(srts.Access_Code_D__c),
                                                             String.valueof(srts.Access_Code_R__c),
                                                             srts.Access_Code_Flag__c,
                                                             srts.SRT_Warrantable_Flag__c,
                                                             srts.Step_Id__c,
                                                             srts.Step_Description__c,
                                                             srts.SRT_Category__c,
                                                             srts.Flex_Flag__c
                                                            ));
                        //srts.Job_Engine_Access_Code__c));

                        // }

                        system.debug('addlistsrtWrapper**'+addlistsrtWrapper);
                        //if(srts.SRT_Select__c ==true){
                        if(srts.isPerformed__c==true){
                            if(srts.type__c != 'Field Action Access')
                                //  totalCampaignSRT = totalCampaignSRT+srts.SRT_Time__c;
                                totalCampaignSRT = totalCampaignSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);
                            if(srts.type__c == 'Field Action Access')
                                totalCampaignAccessTime = totalCampaignAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                        }
                        if(srts.srt_AccessiblityCheck__c==true && srts.type__c == 'Access' && srts.srt_category__c == 'Campaign')
                            totalCampaignSRT = totalCampaignSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);
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
            TrpsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,Service_Job__r.AccessCode__c,
                           (select Id,SRT_ID__c ,Component_Id__c,SRT_Title__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_Time__c,SRT_Time_Formula__c,Access_Code__c,SRT_AccessiblityCheck__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                            //Added fields 
                            SRT_Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Job_Engine_Access_Code__c,FieldAction_Time__c,IsDuplicateSRT__c,
                            //End added fields
                            SRT_Warrantable__c,Adjustment_Reason__c,Flex_Flag__c,Job_Order__c,SRT_Select__c,isPerformed__c,type__c,Extended_Hours__c,SRT_Estimate__c,Assignment__c,Step_Description__c,Step_Id__c,SRT_Category__c from CSS_SRTs__r where (Assignment__c != 'NOT CLAIMABLE' AND Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED') and Type__c!='99Time' order by CSS_AssignmentOrder__c,SRT_ID__c asc) 
                           from CSS_Solution_Component__c where Type__c='TRP' and Service_Job__c =:Wid 
                           and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                                                                                                                                                    and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            integer Compcount = 0;
            system.debug('TrpsrtlstUI:'+TrpsrtlstUI.size());
            if(TrpsrtlstUI!=null){
                //listtrpWrapper = new List<compWrapper>();
                listtrpwrapper1 = new List<trpcompwrapper>();
                //  CompCountVar = false;
                system.debug('TrpsrtlstUI:'+TrpsrtlstUI);
                for(CSS_Solution_Component__c solcomp : TrpsrtlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        integer trpsrtcount = 0;
                        string percentageCov;
                        string addAccesscode;
                        Boolean isPerformedAccessChk;
                        listTRPsrtWrapper1 = new list<trpsrtWrapper>();
                        system.debug('Outsidepartcount*'+trpsrtcount);
                        system.debug('Value:-'+solcomp.CSS_SRTs__r);
                        for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                            // trpsrtcount = trpsrtcount + 1;
                            system.debug('Insidepartcount*'+trpsrtcount);
                            if(srts.Job_Order__c == solcomp.Service_Job__c){
                                if(solcomp.Id == srts.Component_Id__c){
                                    if(!mapaccesscode.containsKey(srts.id)) 
                                        mapaccesscode.put(srts.id,new list<selectoption>());
                                    percentageCov = '100';
                                    If( srts.Job_Engine_Access_Code__c!=null && srts.Job_Engine_Access_Code__c!='R' && (srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 ) && srts.Access_Code_R__c!=0)
                                        addAccesscode = 'R';
                                    else
                                        addAccesscode = srts.Job_Engine_Access_Code__c;

                                    trpsrtcount = trpsrtcount + 1;
                                    //Below code added for the story172627
                                    if(srts.Access_Code__c=='' || srts.Access_Code__c==null||string.isBlank(srts.Access_Code__c))
                                    {
                                        srts.Access_Code__c=srts.SRT_Access_Code__c;
                                    }
                                    CG_UtilityForSRT srtTRP = new CG_UtilityForSRT();
                                    list<selectoption> Accesscodetemp=srtTRP.getAccesscodejoboption(string.valueOf(srts.Access_Code_A__c),string.valueOf(srts.Access_Code_B__c),string.valueOf(srts.Access_Code_C__c),string.valueOf(srts.Access_Code_D__c),string.valueOf(srts.Access_Code_R__c),solcomp.Service_Job__r.AccessCode__c,srts.SRT_Access_Code__c, 'RepairOrFA');

                                    if(Accesscodetemp.size()>0)
                                        mapaccesscode.put(srts.id, Accesscodetemp);
                                    //end
                                    //Added as part of story 177350 -kung fu panda sprint
                                    //srts.isPerformed__c = (srts.Assignment__c!=null && srts.Assignment__c=='PRIMARY');

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
                                                                             srts.SRT_Time_Formula__c, //this stmnt formula works for all
                                                                             srts.Access_Code__c,
                                                                             srts.SRT_Warrantable__c,
                                                                             srts.Adjustment_Reason__c,
                                                                             //srts.SRT_Select__c,
                                                                             isPerformedAccessChk,
                                                                             srts.SRT_Estimate__c,
                                                                             trpsrtcount,
                                                                             percentageCov,
                                                                             srts.type__c,
                                                                             String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0)),
                                                                             addAccesscode,
                                                                             String.valueof(srts.Access_Code_A__c),
                                                                             String.valueof(srts.Access_Code_B__c),
                                                                             String.valueof(srts.Access_Code_C__c),
                                                                             String.valueof(srts.Access_Code_D__c),
                                                                             String.valueof(srts.Access_Code_R__c),
                                                                             srts.Access_Code_Flag__c,
                                                                             srts.SRT_Warrantable_Flag__c,
                                                                             srts.Step_Id__c,
                                                                             srts.Step_Description__c,
                                                                             srts.SRT_Category__c,
                                                                             srts.Flex_Flag__c
                                                                            ));
                                    //srts.Job_Engine_Access_Code__c));
                                }                                
                            }

                            system.debug('listTRPsrtWrapper**'+listTRPsrtWrapper1);
                            //if(srts.SRT_Select__c ==true){
                            if(srts.isPerformed__c==true){
                                if(srts.type__c != 'Field Action Access')
                                    totalTRPSRT = totalTRPSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);
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
                integer srtcount1 = 0;
                string percentageCov1;
                string addAccesscode;
                Boolean isPerformedAccessChk;
                addtrplistsrtWrapper = new list<TRPsrtWrapper>();
                system.debug('Outsidepartcount*'+srtcount1);
                for(CSS_SRT__c srts : additionalSRTList){
                    srtcount1 = srtcount1 + 1;
                    if(!mapaccesscode.containsKey(srts.id)) 
                        mapaccesscode.put(srts.id,new list<selectoption>());
                    system.debug('Insidepartcount*'+srtcount1);
                    if(srts.srt_category__c == 'TRP'){
                        // if(srts.Job_Order__c == solcomp.Service_Job__c){
                        //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                        //compParts = true;
                        //if(solcomp.Id == srts.Component_Id__c){                                    
                        percentageCov1 = '100';
                        If( srts.Job_Engine_Access_Code__c!=null && srts.Job_Engine_Access_Code__c!='R' && (srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 ) && srts.Access_Code_R__c!=0)
                            addAccesscode = 'R';
                        else
                            addAccesscode = srts.Job_Engine_Access_Code__c;

                        //Below code added for the story172627
                        if(srts.Access_Code__c==null || srts.Access_Code__c=='' || string.isBlank(srts.Access_Code__c))
                        {
                            if( srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 && srts.Access_Code_R__c!=0)
                            {
                                srts.Access_Code__c='R';
                                srts.SRT_Access_Code__c='R';
                            }
                            else
                            {
                                srts.Access_Code__c=srts.Job_Engine_Access_Code__c;
                                srts.SRT_Access_Code__c=srts.Job_Engine_Access_Code__c;
                            }
                        }
                        CG_UtilityForSRT srtTRP = new CG_UtilityForSRT();
                        list<selectoption> Accesscodetemp =srtTRP.getAccesscodejoboption(string.valueOf(srts.Access_Code_A__c),string.valueOf(srts.Access_Code_B__c),string.valueOf(srts.Access_Code_C__c),string.valueOf(srts.Access_Code_D__c),string.valueOf(srts.Access_Code_R__c),srts.Job_Order__r.AccessCode__c,srts.SRT_Access_Code__c, 'RepairOrFA');

                        if(Accesscodetemp.size()>0)
                            mapaccesscode.put(srts.id, Accesscodetemp);
                        //end
                        //Added as part of story 177350 -kung fu panda sprint
                        //srts.isPerformed__c = (srts.Assignment__c!=null && srts.Assignment__c=='PRIMARY');

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
                                                                   srts.SRT_Time_Formula__c, //this stmnt formula works for all
                                                                   srts.Access_Code__c,
                                                                   srts.SRT_Warrantable__c,
                                                                   srts.Adjustment_Reason__c,
                                                                   //srts.SRT_Select__c,
                                                                   isPerformedAccessChk,
                                                                   srts.SRT_Estimate__c,
                                                                   srtcount1,
                                                                   percentageCov1,
                                                                   srts.type__c,
                                                                   String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0)),
                                                                   addAccesscode,
                                                                   String.valueof(srts.Access_Code_A__c),
                                                                   String.valueof(srts.Access_Code_B__c),
                                                                   String.valueof(srts.Access_Code_C__c),
                                                                   String.valueof(srts.Access_Code_D__c),
                                                                   String.valueof(srts.Access_Code_R__c),
                                                                   srts.Access_Code_Flag__c,
                                                                   srts.SRT_Warrantable_Flag__c,
                                                                   srts.Step_Id__c,
                                                                   srts.Step_Description__c,
                                                                   srts.SRT_Category__c,
                                                                   srts.Flex_Flag__c
                                                                  ));
                        //srts.Job_Engine_Access_Code__c));

                        // }

                        system.debug('addtrplistsrtWrapper**'+addtrplistsrtWrapper);
                        //if(srts.SRT_Select__c ==true){
                        if(srts.isPerformed__c==true){
                            if(srts.type__c != 'Field Action Access')
                                totalTRPSRT = totalTRPSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);
                            if(srts.type__c == 'Field Action Access')
                                totalTRPAccessTime = totalTRPAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                        }
                        if(srts.srt_AccessiblityCheck__c==true && srts.type__c == 'Access' && srts.srt_category__c == 'TRP')
                            totalTRPSRT = totalTRPSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);
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
            atcsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,Service_Job__r.AccessCode__c,
                           (select Id,SRT_ID__c ,Component_Id__c,SRT_Title__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_AccessiblityCheck__c,SRT_Time__c,SRT_Time_Formula__c,Access_Code__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                            //Added fields 
                            SRT_Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Job_Engine_Access_Code__c,FieldAction_Time__c,IsDuplicateSRT__c,
                            //End added fields
                            SRT_Warrantable__c,Adjustment_Reason__c,Flex_Flag__c,Job_Order__c,SRT_Select__c,isPerformed__c,type__c,Extended_Hours__c,SRT_Estimate__c,Assignment__c,Step_Description__c,Step_Id__c,SRT_Category__c from CSS_SRTs__r where (Assignment__c != 'NOT CLAIMABLE' AND Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED') and Type__c!='99Time' order by CSS_AssignmentOrder__c,SRT_ID__c asc) 
                           from CSS_Solution_Component__c where Type__c='ATC' and Service_Job__c =:Wid 
                           and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                           and Multiple_Times__c=false))];
            system.debug('****atcsrtlstUI CG_CL_JobPlanCampaigns****'+atcsrtlstUI);
            integer Compcount = 0;
            if(atcsrtlstUI!=null){
                listatcWrapper = new List<ATCCompWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : atcsrtlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        integer atcsrtcount = 0;
                        string percentageCov = '100';
                        string addAccesscode;
                        Boolean isPerformedAccessChk;
                        listatcsrtWrapper = new list<atcsrtWrapper>();
                        system.debug('Outsidepartcount*'+atcsrtcount);
                        for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                            atcsrtcount = atcsrtcount + 1;
                            system.debug('Insidepartcount*'+atcsrtcount);
                            if(srts.Job_Order__c == solcomp.Service_Job__c){
                                if(solcomp.Id == srts.Component_Id__c){
                                    //Below code is added for story#172627
                                    if(!mapaccesscode.containsKey(srts.id))
                                        mapaccesscode.put(srts.id,new list<selectoption>());
                                    //percentageCov = '100'; 
                                    /*if(srts.SRT_Hours_Percentage__c==null && srts.SRT_Hours_Percentage__c==0)                                  
                                    percentageCov ='100';
                                else  
                                    percentageCov = String.valueof(srts.SRT_Hours_Percentage__c);*/
                                    percentageCov = String.valueof(srts.SRT_Warrantable__c);
                                    If( srts.Job_Engine_Access_Code__c!=null && srts.Job_Engine_Access_Code__c!='R' && (srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 ) && srts.Access_Code_R__c!=0)
                                        addAccesscode = 'R';
                                    else
                                        addAccesscode = srts.Job_Engine_Access_Code__c;    

                                    //Below code added for the story172627
                                    if(srts.Access_Code__c==null || srts.Access_Code__c=='' || string.isBlank(srts.Access_Code__c))
                                    {
                                        srts.Access_Code__c=srts.SRT_Access_Code__c;
                                    }
                                    CG_UtilityForSRT srtATC = new CG_UtilityForSRT();
                                    list<selectoption> Accesscodetemp=srtATC.getAccesscodejoboption(string.valueOf(srts.Access_Code_A__c),string.valueOf(srts.Access_Code_B__c),string.valueOf(srts.Access_Code_C__c),string.valueOf(srts.Access_Code_D__c),string.valueOf(srts.Access_Code_R__c),solcomp.Service_Job__r.AccessCode__c,srts.SRT_Access_Code__c, 'RepairOrFA');

                                    if(Accesscodetemp.size()>0)
                                        mapaccesscode.put(srts.id, Accesscodetemp);

                                    //Added as part of story 177350 -kung fu panda sprint
                                    //srts.isPerformed__c = (srts.Assignment__c!=null && srts.Assignment__c=='PRIMARY');

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
                                                                            srts.SRT_Time_Formula__c, //this stmnt formula works for all
                                                                            srts.Access_Code__c,
                                                                            percentageCov,
                                                                            srts.Adjustment_Reason__c,
                                                                            //srts.SRT_Select__c,
                                                                            isPerformedAccessChk,
                                                                            srts.SRT_Estimate__c,
                                                                            atcsrtcount,
                                                                            percentageCov,
                                                                            srts.type__c,
                                                                            String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0)),
                                                                            addAccesscode,
                                                                            String.valueof(srts.Access_Code_A__c),
                                                                            String.valueof(srts.Access_Code_B__c),
                                                                            String.valueof(srts.Access_Code_C__c),
                                                                            String.valueof(srts.Access_Code_D__c),
                                                                            String.valueof(srts.Access_Code_R__c),
                                                                            srts.Access_Code_Flag__c,
                                                                            srts.SRT_Warrantable_Flag__c,
                                                                            srts.Step_Id__c,
                                                                            srts.Step_Description__c,
                                                                            srts.SRT_Category__c,
                                                                            srts.Flex_Flag__c
                                                                           ));
                                    //srts.Job_Engine_Access_Code__c));
                                }                                
                            }

                            system.debug('listatcsrtWrapper**'+listatcsrtWrapper);
                            //if(srts.SRT_Select__c ==true){
                            if(srts.isPerformed__c==true){
                                if(srts.type__c != 'Field Action Access')
                                    totalATCSRT = totalATCSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);
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
            System.debug('TEstas');
            addlistatcWrapper = new List<ATCcompWrapper>();
            System.debug('TEstas2'+additionalSRTList);
            ///Compcount = Compcount + 1;
            if(additionalSRTList != null && additionalSRTList.size()>0){
                integer srtcount1 = 0;
                string percentageCov1;
                string addAccesscode;
                Boolean isPerformedAccessChk;
                addatclistsrtWrapper = new list<atcsrtWrapper>();
                system.debug('Outsidepartcount*'+srtcount1);
                for(CSS_SRT__c srts : additionalSRTList){
                    srtcount1 = srtcount1 + 1;
                    //Below code is added for story#172627
                    if(!mapaccesscode.containsKey(srts.id))
                        mapaccesscode.put(srts.id,new list<selectoption>());
                    system.debug('Insidepartcount*'+srtcount1);
                    if(srts.srt_category__c == 'ATC'){
                        // if(srts.Job_Order__c == solcomp.Service_Job__c){
                        //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                        //compParts = true;
                        //if(solcomp.Id == srts.Component_Id__c){                                    
                        percentageCov1 = '100';
                        If( srts.Job_Engine_Access_Code__c!=null && srts.Job_Engine_Access_Code__c!='R' && (srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 ) && srts.Access_Code_R__c!=0)
                            addAccesscode = 'R';

                        else
                            addAccesscode = srts.Job_Engine_Access_Code__c; 

                        //Below code added for the story#172627   
                        IF(srts.Access_Code__c==null || srts.Access_Code__c=='' || string.isBlank(srts.Access_Code__c))
                        {
                            if( srts.Access_Code_A__c==0 && srts.Access_Code_B__c==0 && srts.Access_Code_C__c==0 && srts.Access_Code_D__c==0 && srts.Access_Code_R__c!=0)
                            {
                                srts.Access_Code__c='R';
                                srts.SRT_Access_Code__c='R';
                            }
                            else
                            {
                                srts.Access_Code__c=srts.Job_Engine_Access_Code__c;
                                srts.SRT_Access_Code__c=srts.Job_Engine_Access_Code__c;
                            }
                        }
                        CG_UtilityForSRT srtATC = new CG_UtilityForSRT();
                        list<selectoption> Accesscodetemp =srtATC.getAccesscodejoboption(string.valueOf(srts.Access_Code_A__c),string.valueOf(srts.Access_Code_B__c),string.valueOf(srts.Access_Code_C__c),string.valueOf(srts.Access_Code_D__c),string.valueOf(srts.Access_Code_R__c),srts.Job_Order__r.AccessCode__c,srts.SRT_Access_Code__c, 'RepairOrFA');

                        if(Accesscodetemp.size()>0)
                            mapaccesscode.put(srts.id, Accesscodetemp);
                        //end
                        //Added as part of story 177350 -kung fu panda sprint
                        //srts.isPerformed__c = (srts.Assignment__c!=null && srts.Assignment__c=='PRIMARY');

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
                                                                   srts.SRT_Time_Formula__c, //this stmnt formula works for all
                                                                   srts.Access_Code__c,
                                                                   srts.SRT_Warrantable__c,
                                                                   srts.Adjustment_Reason__c,
                                                                   //srts.SRT_Select__c,
                                                                   isPerformedAccessChk,
                                                                   srts.SRT_Estimate__c,
                                                                   srtcount1,
                                                                   percentageCov1,
                                                                   srts.type__c,
                                                                   String.valueof((srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0)),
                                                                   addAccesscode,
                                                                   String.valueof(srts.Access_Code_A__c),
                                                                   String.valueof(srts.Access_Code_B__c),
                                                                   String.valueof(srts.Access_Code_C__c),
                                                                   String.valueof(srts.Access_Code_D__c),
                                                                   String.valueof(srts.Access_Code_R__c),
                                                                   srts.Access_Code_Flag__c,
                                                                   srts.SRT_Warrantable_Flag__c,
                                                                   srts.Step_Id__c,
                                                                   srts.Step_Description__c,
                                                                   srts.SRT_Category__c,
                                                                   srts.Flex_Flag__c
                                                                  ));
                        //srts.Job_Engine_Access_Code__c));

                        // }

                        system.debug('addatclistsrtWrapper**'+addatclistsrtWrapper);
                        //if(srts.SRT_Select__c ==true){
                        if(srts.isPerformed__c==true){
                            if(srts.type__c != 'Field Action Access')
                                totalATCSRT = totalATCSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);
                            if(srts.type__c == 'Field Action Access')
                                totalATCAccessTime = totalATCAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                        }
                        if(srts.srt_AccessiblityCheck__c==true && srts.type__c == 'Access' && srts.srt_category__c == 'ATC')
                            totalATCSRT = totalATCSRT+(srts.Extended_Hours__c != null ? srts.Extended_Hours__c : 0.0);
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
    //Method for getting AdjustmentReason values  
    public list<selectoption> getAdjustmentReason(){
        list<selectoption> option = new list<selectoption>();
        option.add(new selectOption(('----Select One----'),('----Select One----')));
        option.add(new selectOption(('Not Justified Per Failure Code'),('Not Justified Per Failure Code')));
        option.add(new selectOption(('Partial Re-Assembly'),('Partial Re-Assembly')));
        option.add(new selectOption(('Penalty'),('Penalty')));
        option.add(new selectOption(('Travel SRT’s Incorrectly Used'),('Travel SRT’s Incorrectly Used')));
        return option;
    }
    //Method for saving all srt and component data into database
    public PageReference saveALLSRTData(){
        system.debug('in saveALLSRTData...'); 
        AllsrtlstUI = new list<CSS_Solution_Component__c>(); 
        List<CSS_SRT__c> srtlstcamp = new List<CSS_SRT__c>();
        List<CSS_SRT__c> allsrtsList = new List<CSS_SRT__c>();
        system.debug('New List'+srtlstcamp.size());               
        try{
            //save funtionality for CAMPAIGN records
            if(listcompwrapper != null && listcompwrapper.size()>0){
                for(CompWrapper CompWrap: listcompwrapper){
                    for(srtWrapper srtwrap : CompWrap.srtWrapper){
                        system.debug('InsideFor srtwrap>:'+srtwrap);
                        CSS_SRT__c srtscamp = new CSS_SRT__c();
                        srtscamp.Id = srtwrap.srtids;
                        srtscamp.SRT_ID__c = srtwrap.SRTCode;
                        //For FlexSRTs, SRT Time saving
                        System.debug('srtwrap.srtTime>:'+srtwrap.srtTime);
                        if(srtwrap.flexFlag == true){
                            srtscamp.SRT_Time__c = srtwrap.srtTime;
                        }
                        //if(srtwrap.quantity == '' || srtwrap.quantity == null)
                        //srtwrap.quantity = '0';
                        srtscamp.SRT_Quantity__c = srtwrap.quantity;
                        //srtscamp.Additional_SRT_Calculated__c  = srtwrap.ACCESSSRTTime;
                        srtscamp.SRT_Title__c = srtwrap.SRTDescription;
                        srtscamp.Job_Order__c = Wid;
                        srtscamp.Access_Code__c = srtwrap.AccessCode;
                        // atccamp.SRT_Hours_Percentage__c = Decimal.valueOf(atcwrap.SRTHours);
                        if(srtwrap.SRTHours != '' && srtwrap.SRTHours != null){
                            srtscamp.SRT_Warrantable__c = srtwrap.SRTHours;
                        }else{
                            srtscamp.SRT_Warrantable__c ='100';
                        }                        
                        srtscamp.Adjustment_Reason__c  = srtwrap.AdjustmentReason;
                        //srtscamp.SRT_Select__c = srtwrap.selectedComponent;                        
                        if(srtwrap.type=='Field Action Access'){
                            srtscamp.SRT_AccessiblityCheck__c=srtwrap.selectedComponent;
                        }
                        else{
                            srtscamp.isPerformed__c = srtwrap.selectedComponent;
                        }
                        //srtscamp.isPerformed__c = srtwrap.selectedComponent;
                        srtscamp.SRT_Estimate__c = srtwrap.estimate;
                        allsrtsList.add(srtscamp);

                    }
                }

                system.debug('solcomplst*'+srtlstcamp);
            } 
            //save funtionality for TRP records
            if(listtrpwrapper1 != null && listtrpwrapper1.size()>0){
                for(TRPCompWrapper compwraptrp : listtrpwrapper1){
                    for(trpsrtWrapper wraptrp : compwraptrp.trpsrtWrapper){
                        CSS_SRT__c trpcamp = new CSS_SRT__c();
                        trpcamp.Id = wraptrp.srtids;
                        trpcamp.SRT_ID__c = wraptrp.SRTCode;
                        //For FlexSRTs, SRT Time saving
                        if(wraptrp.flexFlag == true){
                            trpcamp.SRT_Time__c = wraptrp.srtTime;
                        }
                        //if(wraptrp.quantity == '' || wraptrp.quantity == null)
                        //wraptrp.quantity = '0';
                        trpcamp.SRT_Quantity__c = wraptrp.quantity;
                        //trpcamp.Additional_SRT_Calculated__c  = wraptrp.ACCESSSRTTime;
                        trpcamp.SRT_Title__c = wraptrp.SRTDescription;
                        trpcamp.Job_Order__c = Wid;
                        trpcamp.Access_Code__c = wraptrp.AccessCode;
                        if(wraptrp.SRTHours != '' && wraptrp.SRTHours != null)
                            trpcamp.SRT_Warrantable__c = wraptrp.SRTHours;
                        trpcamp.Adjustment_Reason__c  = wraptrp.AdjustmentReason;
                        //trpcamp.SRT_Select__c = wraptrp.selectedComponent; //Kalpana
                        if(wraptrp.type=='Field Action Access'){
                            trpcamp.SRT_AccessiblityCheck__c=wraptrp.selectedComponent;
                        }
                        else{
                            trpcamp.isPerformed__c = wraptrp.selectedComponent;
                        }
                        //trpcamp.isPerformed__c = wraptrp.selectedComponent;
                        trpcamp.SRT_Estimate__c = wraptrp.estimate;
                        allsrtsList.add(trpcamp);
                    }
                }
                system.debug('InsideIF*');
                // system.debug('srtlstTrp*'+srtlstTrp);
            }
            //save funtionality for ATC records
            if(listatcwrapper != null && listatcwrapper.size()>0){
                for(ATCCompWrapper CompWrapAtc: listatcwrapper){
                    for(atcsrtWrapper atcwrap : CompWrapAtc.atcsrtwrapper){
                        if(atcwrap != null){
                            CSS_SRT__c atccamp = new CSS_SRT__c();
                            atccamp.Id = atcwrap.srtids;
                            atccamp.SRT_ID__c = atcwrap.SRTCode;
                            //For FlexSRTs, SRT Time saving
                            if(atcwrap.flexFlag == true){
                                atccamp.SRT_Time__c = atcwrap.srtTime;
                            }
                            //if(atcwrap.quantity == '' || atcwrap.quantity == null)
                            //  atcwrap.quantity = '0';
                            atccamp.SRT_Quantity__c = atcwrap.quantity;
                            // atccamp.Additional_SRT_Calculated__c  = atcwrap.ACCESSSRTTime;
                            atccamp.SRT_Title__c = atcwrap.SRTDescription;
                            atccamp.Job_Order__c = Wid;
                            atccamp.Access_Code__c = atcwrap.AccessCode;
                            //if(atcwrap.SRTHours != '' && atcwrap.SRTHours != null)
                            atccamp.SRT_Warrantable__c = atcwrap.SRTHours;
                            atccamp.Adjustment_Reason__c  = atcwrap.AdjustmentReason;
                            //atccamp.SRT_Select__c = atcwrap.selectedComponent;
                            if(atcwrap.type=='Field Action Access'){
                                atccamp.SRT_AccessiblityCheck__c=atcwrap.selectedComponent;
                            }
                            else{
                                atccamp.isPerformed__c = atcwrap.selectedComponent;
                            }
                            //atccamp.isPerformed__c = atcwrap.selectedComponent;
                            atccamp.SRT_Estimate__c = atcwrap.estimate;
                            allsrtsList.add(atccamp);
                        }
                    }
                }
            }

            //save funtionality for Additional CAMPAIGN records
            if(addlistcompwrapper != null && addlistcompwrapper.size()>0){
                for(CompWrapper CompWrap: addlistcompwrapper){
                    for(srtWrapper srtwrap : CompWrap.srtWrapper){
                        system.debug('InsideFor*');
                        CSS_SRT__c srtscamp = new CSS_SRT__c();
                        srtscamp.Id = srtwrap.srtids;
                        srtscamp.SRT_ID__c = srtwrap.SRTCode;
                        //For FlexSRTs, SRT Time saving
                        System.debug('srtwrap.srtTime>:'+srtwrap.srtTime);
                        if(srtwrap.flexFlag == true){
                            srtscamp.SRT_Time__c = srtwrap.srtTime;
                        }
                        //if(srtwrap.quantity == '' || srtwrap.quantity == null)
                        //srtwrap.quantity = '0';
                        srtscamp.SRT_Quantity__c = srtwrap.quantity;
                        //srtscamp.Additional_SRT_Calculated__c  = srtwrap.ACCESSSRTTime;
                        srtscamp.SRT_Title__c = srtwrap.SRTDescription;
                        srtscamp.Job_Order__c = Wid;
                        srtscamp.Access_Code__c = srtwrap.AccessCode;
                        // atccamp.SRT_Hours_Percentage__c = Decimal.valueOf(atcwrap.SRTHours);
                        if(srtwrap.SRTHours != '' && srtwrap.SRTHours != null){
                            srtscamp.SRT_Warrantable__c = srtwrap.SRTHours;
                        }else{
                            srtscamp.SRT_Warrantable__c ='100';
                        }                        
                        srtscamp.Adjustment_Reason__c  = srtwrap.AdjustmentReason;
                        //srtscamp.SRT_Select__c = srtwrap.selectedComponent;
                        if(srtwrap.type=='Access'){
                            srtscamp.SRT_AccessiblityCheck__c=srtwrap.selectedComponent;
                        }
                        else{
                            srtscamp.isPerformed__c = srtwrap.selectedComponent;
                        }
                        //srtscamp.isPerformed__c = srtwrap.selectedComponent;
                        srtscamp.SRT_Estimate__c = srtwrap.estimate;
                        allsrtsList.add(srtscamp);

                    }
                }

                system.debug('solcomplst*'+srtlstcamp);
            } 

            //save funtionality for Additional TRP records
            if(addlisttrpwrapper != null && addlisttrpwrapper.size()>0){
                for(TRPCompWrapper compwraptrp : addlisttrpwrapper){
                    for(trpsrtWrapper wraptrp : compwraptrp.trpsrtWrapper){
                        CSS_SRT__c trpcamp = new CSS_SRT__c();
                        trpcamp.Id = wraptrp.srtids;
                        trpcamp.SRT_ID__c = wraptrp.SRTCode;
                        //For FlexSRTs, SRT Time saving
                        if(wraptrp.flexFlag == true){
                            trpcamp.SRT_Time__c = wraptrp.srtTime;
                        }
                        //if(wraptrp.quantity == '' || wraptrp.quantity == null)
                        //wraptrp.quantity = '0';
                        trpcamp.SRT_Quantity__c = wraptrp.quantity;
                        //trpcamp.Additional_SRT_Calculated__c  = wraptrp.ACCESSSRTTime;
                        trpcamp.SRT_Title__c = wraptrp.SRTDescription;
                        trpcamp.Job_Order__c = Wid;
                        trpcamp.Access_Code__c = wraptrp.AccessCode;
                        if(wraptrp.SRTHours != '' && wraptrp.SRTHours != null)
                            trpcamp.SRT_Warrantable__c = wraptrp.SRTHours;
                        trpcamp.Adjustment_Reason__c  = wraptrp.AdjustmentReason;
                        //trpcamp.SRT_Select__c = wraptrp.selectedComponent; //Kalpana
                        if(wraptrp.type=='Access'){
                            trpcamp.SRT_AccessiblityCheck__c=wraptrp.selectedComponent;
                        }
                        else{
                            trpcamp.isPerformed__c = wraptrp.selectedComponent;
                        }
                        //trpcamp.isPerformed__c = wraptrp.selectedComponent;
                        trpcamp.SRT_Estimate__c = wraptrp.estimate;
                        allsrtsList.add(trpcamp);
                    }
                }
                system.debug('InsideIF*');
                // system.debug('srtlstTrp*'+srtlstTrp);
            }
            //save funtionality for Additional ATC records
            if(addlistatcwrapper != null && addlistatcwrapper.size()>0){
                for(ATCCompWrapper CompWrapAtc: addlistatcwrapper){
                    for(atcsrtWrapper atcwrap : CompWrapAtc.atcsrtwrapper){
                        if(atcwrap != null){
                            CSS_SRT__c atccamp = new CSS_SRT__c();
                            atccamp.Id = atcwrap.srtids;
                            atccamp.SRT_ID__c = atcwrap.SRTCode;
                            //For FlexSRTs, SRT Time saving
                            if(atcwrap.flexFlag == true){
                                atccamp.SRT_Time__c = atcwrap.srtTime;
                            }
                            //if(atcwrap.quantity == '' || atcwrap.quantity == null)
                            //  atcwrap.quantity = '0';
                            atccamp.SRT_Quantity__c = atcwrap.quantity;
                            // atccamp.Additional_SRT_Calculated__c  = atcwrap.ACCESSSRTTime;
                            atccamp.SRT_Title__c = atcwrap.SRTDescription;
                            atccamp.Job_Order__c = Wid;
                            atccamp.Access_Code__c = atcwrap.AccessCode;
                            //if(atcwrap.SRTHours != '' && atcwrap.SRTHours != null)
                            atccamp.SRT_Warrantable__c = atcwrap.SRTHours;
                            atccamp.Adjustment_Reason__c  = atcwrap.AdjustmentReason;
                            //atccamp.SRT_Select__c = atcwrap.selectedComponent;
                            if(atcwrap.type=='Access'){
                                atccamp.SRT_AccessiblityCheck__c=atcwrap.selectedComponent;
                            }
                            else{
                                atccamp.isPerformed__c = atcwrap.selectedComponent;
                            }
                            //atccamp.isPerformed__c = atcwrap.selectedComponent;
                            atccamp.SRT_Estimate__c = atcwrap.estimate;
                            allsrtsList.add(atccamp);
                        }
                    }
                }
            }

            system.debug('isSavedInitially**'+isSaved);
            system.debug('allsrtsList * '+allsrtsList);
            if(allsrtsList != null && allsrtsList.size()>0){


                update allsrtsList;

                //Calling all methods again in save method for getting recent updations on Total srt time and access time for CAMPAIGN,TRP and ATC     
                getAllCampSrtsData();
                getAllTRPSrtsData();
                getAllATCSrtsData();  
                isSaved = true;
                system.debug('isSAved***'+isSaved);

            }
            system.debug('allsrtsList * '+allsrtsList);
        }
        catch(exception e){

            system.debug('Entered into catch block of save parts method in css_CampaignController class' );
            system.debug('Campaign Controller Exception --> '+ e.getLineNumber() + ' ' +e.getMessage() );
        } 
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        PageReference pageRef = new PageReference(sDestURL+'id='+Wid); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    ///_________start code for getting recent srt time anm access time  before save the data into database as per defect #173842[New functionality],-By RAJESH 13th Dec 2018    
    public boolean checkBoxSelected {get;set;}
    //Method for getting recent srt time anm access time for CAMPAIGN
    public void getCampaignSRTTime(){
        try{
            system.debug('inside method getCampaignSRTTime');
            system.debug('checkBoxSelected inside method getCampaignSRTTime'+checkBoxSelected);
            decimal camSRTTime = 0;
            for(CompWrapper CompWrap:listcompWrapper){
                for(srtWrapper srtwrap : CompWrap.srtWrapper){
                    system.debug('***srtwrap.type***'+srtwrap.type);
                    if(srtwrap.selectedComponent ==true && (checkBoxSelected==true || checkBoxSelected==false)){
                        system.debug('***srtwrap.extendedHours***'+srtwrap.extendedHours);
                        camSRTTime = camSRTTime +(decimal.valueOf(srtwrap.extendedHours) != null ? decimal.valueOf(srtwrap.extendedHours) : 0.0);
                        system.debug('***camSRTTime***'+camSRTTime);
                    }
                }
            } 
            for(CompWrapper addlstWrap:addlistcompWrapper){
                for(srtWrapper srtwrap : addlstWrap.srtWrapper){
                    system.debug('***srtwrap.type***'+srtwrap.type);
                    if(srtwrap.selectedComponent ==true && (checkBoxSelected==true || checkBoxSelected==false)){
                        system.debug('***srtwrap.extendedHours***'+srtwrap.extendedHours);
                        camSRTTime = camSRTTime +(decimal.valueOf(srtwrap.extendedHours) != null ? decimal.valueOf(srtwrap.extendedHours) : 0.0);
                        system.debug('***camSRTTime***'+camSRTTime);
                    }
                }
            }
            totalCampaignSRT=camSRTTime;
            system.debug('***totalCampaignSRT***'+totalCampaignSRT);
        }
        catch(exception e){
            system.debug('Entered into catch block of totalCampaignSRT value***'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }
    //Method for getting recent srt time anm access time for TRP
    public void getTRPSRTTime(){
        try{
            system.debug('inside method getTRPSRTTime');
            system.debug('checkBoxSelected inside method getTRPSRTTime'+checkBoxSelected);
            decimal trpSRTTime = 0;
            for(TRPCompWrapper tRPWrap:listtrpWrapper1){
                for(TRPsrtWrapper srtwrap : tRPWrap.trpsrtWrapper){
                    system.debug('***srtwrap.type***'+srtwrap.type);
                    if(srtwrap.selectedComponent ==true && (checkBoxSelected==true || checkBoxSelected==false)){
                        system.debug('***srtwrap.extendedHours***'+srtwrap.extendedHours);
                        trpSRTTime = trpSRTTime +(decimal.valueOf(srtwrap.extendedHours) != null ? decimal.valueOf(srtwrap.extendedHours) : 0.0);
                        system.debug('***trpSRTTime***'+trpSRTTime);
                    }
                }
            } 
            for(TRPCompWrapper addlstWrap:addlisttrpWrapper){
                for(TRPsrtWrapper srtwrap : addlstWrap.trpsrtWrapper){
                    system.debug('***srtwrap.type***'+srtwrap.type);
                    if(srtwrap.selectedComponent ==true && (checkBoxSelected==true || checkBoxSelected==false)){
                        system.debug('***srtwrap.extendedHours***'+srtwrap.extendedHours);
                        trpSRTTime = trpSRTTime +(decimal.valueOf(srtwrap.extendedHours) != null ? decimal.valueOf(srtwrap.extendedHours) : 0.0);
                        system.debug('***trpSRTTime***'+trpSRTTime);
                    }
                }
            }
            totalTRPSRT=trpSRTTime;
            system.debug('***totalTRPSRT***'+totalTRPSRT);
        }
        catch(exception e){
            system.debug('Entered into catch block of totalTRPSRT value***'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }
    //Method for getting recent srt time anm access time for ATC
    public void getATCSRTTime(){
        try{
            system.debug('inside method getATCSRTTime');
            system.debug('checkBoxSelected inside method getATCSRTTime'+checkBoxSelected);
            decimal atcSRTTime = 0;
            for(ATCCompWrapper aTCWrap:listatcWrapper){
                for(ATCsrtWrapper srtwrap : aTCWrap.atcsrtWrapper){
                    system.debug('***srtwrap.type***'+srtwrap.type);
                    if(srtwrap.selectedComponent ==true && (checkBoxSelected==true || checkBoxSelected==false)){
                        system.debug('***srtwrap.extendedHours***'+srtwrap.extendedHours);
                        atcSRTTime = atcSRTTime +(decimal.valueOf(srtwrap.extendedHours) != null ? decimal.valueOf(srtwrap.extendedHours) : 0.0);
                        system.debug('***atcSRTTime***'+atcSRTTime);
                    }
                }
            } 
            for(ATCCompWrapper addlstWrap:addlistatcWrapper){
                for(ATCsrtWrapper srtwrap : addlstWrap.atcsrtWrapper){
                    system.debug('***srtwrap.type***'+srtwrap.type);
                    if(srtwrap.selectedComponent ==true && (checkBoxSelected==true || checkBoxSelected==false)){
                        system.debug('***srtwrap.extendedHours***'+srtwrap.extendedHours);
                        atcSRTTime = atcSRTTime +(decimal.valueOf(srtwrap.extendedHours) != null ? decimal.valueOf(srtwrap.extendedHours) : 0.0);
                        system.debug('***atcSRTTime***'+atcSRTTime);
                    }
                }
            }
            totalATCSRT=atcSRTTime;
            system.debug('***totalATCSRT***'+totalATCSRT);
        }
        catch(exception e){
            system.debug('Entered into catch block of totalTRPSRT value***'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }
    ////__________________End as per defect #173842[New functionality],-By RAJESH 13th Dec 2018


    //Method for reset the privous values in SRT all sections
    public void ResetALLSRTData(){
        getAllCampSrtsData();
        getAllTRPSrtsData();
        getAllATCSrtsData();
    }


    // Story GSSC-20 Begin
    public String lineItemStepIdCampaigns {get;set;} 
    public String SRTContentCampaigns{get;set;}
    public void callAccessStepDetailsCampaigns(){
        try{
            system.debug('lineItemStepIdCampaigns  ' + lineItemStepIdCampaigns);
            system.debug('EquipIdFA ' + EquipIdFA);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipIdFA,lineItemStepIdCampaigns);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        SRTContentCampaigns = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                SRTContentCampaigns='';
            
            SRTContentCampaigns = SRTContentCampaigns.replaceAll('\\n','<br/>');
            SRTContentCampaigns = SRTContentCampaigns.replaceAll('\n','<br/>');

            system.debug('SRTContentCampaigns ' + SRTContentCampaigns);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void NotesPopupOkCampaigns(){
        SRTContentCampaigns='';
        system.debug('Ok button>> SRTContentCampaigns ' + SRTContentCampaigns);
    }



    //TRP 

    public String lineItemStepIdTRP {get;set;} 
    public String SRTContentTRP{get;set;}
    public void callAccessStepDetailsTRP(){
        try{
            system.debug('lineItemStepIdTRP  ' + lineItemStepIdTRP);
            system.debug('EquipIdFA ' + EquipIdFA);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipIdFA,lineItemStepIdTRP);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        SRTContentTRP = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                SRTContentTRP='';
            
            SRTContentTRP = SRTContentTRP.replaceAll('\\n','<br/>');
            SRTContentTRP = SRTContentTRP.replaceAll('\n','<br/>');

            system.debug('SRTContentTRP ' + SRTContentTRP);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void NotesPopupOkTRP(){
        SRTContentTRP='';
        system.debug('Ok button>> SRTContentTRP ' + SRTContentTRP );
    }

    //ATC

    public String lineItemStepIdATC {get;set;} 
    public String SRTContentATC{get;set;}
    public void callAccessStepDetailsATC(){
        try{
            system.debug('lineItemStepIdATC  ' + lineItemStepIdATC);
            system.debug('EquipIdFA ' + EquipIdFA);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipIdFA,lineItemStepIdATC);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        SRTContentATC = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                SRTContentATC ='';
            
            SRTContentATC = SRTContentATC.replaceAll('\\n','<br/>');
            SRTContentATC = SRTContentATC.replaceAll('\n','<br/>');

            system.debug('SRTContentATC ' + SRTContentATC);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void NotesPopupOkATc(){
        SRTContentATC='';
        system.debug('Ok button>> SRTContentATC ' + SRTContentATC);
    }


    // Story GSSC-20 End



    //wrapper classes for COMPONENT and SRT when type is equal to CAMPAIGN
    public class CompWrapper{
        public Id CompIds {get;set;}
        public string FieldActNum {get;set;}
        public list<srtWrapper> srtWrapper {get;set;}
        public integer srtcount{get;set;}
        public CompWrapper(Id CompIds,string FieldActNum,list<srtWrapper> srtWrapper,integer srtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.srtWrapper = srtWrapper;
            this.srtcount = srtcount;
        }
    }    
    public class srtWrapper{
        public Id srtids {get;set;}
        public String SRTCode  {get;set;} 
        public String SRTDescription  {get;set;}
        public Decimal quantity {get;set;} 
        public String ACCESSSRTTime {get;set;} 
        public Decimal SRTTime {get;set;} 
        public String AccessCode {get;set;} 
        public String SRTHours {get;set;}
        public String AdjustmentReason  {get;set;}
        public Boolean selectedComponent {get;set;}
        public Boolean estimate {get;set;} 
        public integer srtcount{get;set;}
        public String percentage{get;set;} 
        public String type{get;set;}
        public String extendedHours{get;set;}
        public String jobAccessCode{get;set;}
        public String accessCodeA{get;set;}
        public String accessCodeB{get;set;}
        public String accessCodeC{get;set;}
        public String accessCodeD{get;set;}
        public String accessCodeR{get;set;}
        public Boolean accessCodeFlag {get;set;}
        public Boolean percenReqFlag {get;set;}
        public String StepId {get;set;}
        public String StepDescription {get;set;}
        public String SRTCategory {get;set;}
        public Boolean flexFlag {get;set;}


        public srtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedComponent,Boolean estimate,integer srtcount,String percentage,String type,String extendedHours,string jobAccessCode,string accessCodeA,string accessCodeB,string accessCodeC,string accessCodeD,string accessCodeR,Boolean accessCodeFlag,Boolean percenReqFlag,  String StepId, String StepDescription, String SRTCategory, Boolean flexFlag) {

            this.srtids = srtids;
            this.flexFlag = flexFlag;
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
            this.jobAccessCode = jobAccessCode;
            this.accessCodeA = accessCodeA;
            this.accessCodeB = accessCodeB;
            this.accessCodeC = accessCodeC;
            this.accessCodeD = accessCodeD;
            this.accessCodeR = accessCodeR;
            this.accessCodeFlag = accessCodeFlag;
            this.percenReqFlag = percenReqFlag;
            this.StepId = StepId;
            this.StepDescription = StepDescription;
            this.SRTCategory = SRTCategory;

        }       
    }
    //wrapper classes for COMPONENT and SRT when type is equal to TRP
    public class TRPsrtWrapper{
        public Id srtids {get;set;}
        public String SRTCode  {get;set;} 
        public String SRTDescription  {get;set;}
        public Decimal quantity {get;set;} 
        public String ACCESSSRTTime {get;set;} 
        public Decimal SRTTime {get;set;} 
        public String AccessCode {get;set;} 
        public String SRTHours {get;set;}
        public String AdjustmentReason  {get;set;}
        public Boolean selectedComponent {get;set;} 
        public Boolean estimate {get;set;}
        public integer trpsrtcount{get;set;}
        public String percentage{get;set;} 
        public String type{get;set;}
        public String extendedHours{get;set;}
        public String jobAccessCode{get;set;}
        public String accessCodeA{get;set;}
        public String accessCodeB{get;set;}
        public String accessCodeC{get;set;}
        public String accessCodeD{get;set;}
        public String accessCodeR{get;set;}
        public Boolean accessCodeFlag {get;set;}
        public Boolean percenReqFlag {get;set;}
        public String StepId {get;set;}
        public String StepDescription {get;set;}
        public String SRTCategory {get;set;}
        public Boolean flexFlag {get;set;}

        public TRPsrtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedcomponent,Boolean estimate,integer trpsrtcount,String percentage,String type,String extendedHours,String jobAccessCode,string accessCodeA,string accessCodeB,string accessCodeC,string accessCodeD,string accessCodeR,Boolean accessCodeFlag,Boolean percenReqFlag, String StepId, String StepDescription, String SRTCategory, Boolean flexFlag) {

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
            this.jobAccessCode = jobAccessCode;
            this.accessCodeA = accessCodeA;
            this.accessCodeB = accessCodeB;
            this.accessCodeC = accessCodeC;
            this.accessCodeD = accessCodeD;
            this.accessCodeR = accessCodeR;
            this.accessCodeFlag = accessCodeFlag;
            this.percenReqFlag = percenReqFlag;
            this.StepId = StepId;
            this.StepDescription = StepDescription;
            this.SRTCategory = SRTCategory;
            this.flexFlag = flexFlag;

        }

    }
    public class TRPCompWrapper{
        public Id CompIds {get;set;}
        public string FieldActNum {get;set;}
        public list<TRPsrtWrapper> TRPsrtWrapper {get;set;}
        public integer trpsrtcount{get;set;}
        public TRPCompWrapper(Id CompIds,string FieldActNum,list<TRPsrtWrapper> TRPsrtWrapper,integer trpsrtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.TRPsrtWrapper = TRPsrtWrapper;
            this.trpsrtcount = trpsrtcount;
        }
    }
    //wrapper classes for COMPONENT and SRT when type is equal to ATC
    public class ATCsrtWrapper{
        public Id srtids {get;set;}
        public String SRTCode  {get;set;} 
        public String SRTDescription  {get;set;}
        public Decimal quantity {get;set;} 
        public String ACCESSSRTTime {get;set;} 
        public Decimal SRTTime {get;set;} 
        public String AccessCode {get;set;} 
        public String SRTHours {get;set;}
        public String AdjustmentReason  {get;set;}
        public Boolean selectedComponent {get;set;} 
        public Boolean estimate {get;set;}
        public integer atcsrtcount{get;set;}
        public String percentage{get;set;} 
        public String type{get;set;} 
        public String extendedHours{get;set;}
        public String jobAccessCode{get;set;}
        public String accessCodeA{get;set;}
        public String accessCodeB{get;set;}
        public String accessCodeC{get;set;}
        public String accessCodeD{get;set;}
        public String accessCodeR{get;set;}
        public Boolean accessCodeFlag {get;set;}
        public Boolean percenReqFlag {get;set;}
        public String StepId {get;set;}
        public String StepDescription {get;set;}
        public String SRTCategory {get;set;}
        public Boolean flexFlag{get;set;}

        public ATCsrtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedcomponent,Boolean estimate,integer atcsrtcount,String percentage,String type,String extendedHours,string jobAccessCode,string accessCodeA,string accessCodeB,string accessCodeC,string accessCodeD,string accessCodeR,Boolean accessCodeFlag,Boolean percenReqFlag, String StepId, String StepDescription, String SRTCategory, Boolean flexFlag) {

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
            this.jobAccessCode = jobAccessCode;
            this.accessCodeA = accessCodeA;
            this.accessCodeB = accessCodeB;
            this.accessCodeC = accessCodeC;
            this.accessCodeD = accessCodeD;
            this.accessCodeR = accessCodeR;
            this.accessCodeFlag = accessCodeFlag;
            this.percenReqFlag = percenReqFlag;
            this.StepId = StepId;
            this.StepDescription = StepDescription;
            this.SRTCategory = SRTCategory;
            this.flexFlag = flexFlag;

        }

    }
    public class ATCCompWrapper{
        public Id CompIds {get;set;}
        public string FieldActNum {get;set;}
        public list<ATCsrtWrapper> ATCsrtWrapper {get;set;}
        public integer atcsrtcount{get;set;}
        public ATCCompWrapper(Id CompIds,string FieldActNum,list<ATCsrtWrapper> ATCsrtWrapper,integer atcsrtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.ATCsrtWrapper = ATCsrtWrapper;
            this.atcsrtcount = atcsrtcount;
        }
    }

}