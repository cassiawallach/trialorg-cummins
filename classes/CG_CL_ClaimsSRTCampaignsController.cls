/*
 * Block comments with details of changes
 */
public class CG_CL_ClaimsSRTCampaignsController
{

    public String sVfComp;
    public list<CompWrapper> listcompWrapper {get;set;}
    public list<srtWrapper> srtWrapper {get;set;}
    public list<CSS_Solution_Component__c> campsrtlstUI;    
    public Decimal totalCampaignSRT{get;set;}
    public Decimal totalCampaignAccessTime{get;set;}
    public Id Wid{get; set;}
    public Id Cid{get; set;}
    public Decimal totalATCSRT{get;set;}
    public Decimal totalATCAccessTime{get;set;}
    public list<srtWrapper> listsrtWrapper {get;set;}
    public Decimal totalTRPSRT{get;set;}
    public Decimal totalTRPAccessTime{get;set;}
    public List<srtWrapper> diagListWrap{get;set;}
    public list<sortWrapper> lstDiagWrapSRT{get;set;}

    public List<srtWrapper> additionalDiagListWrap{get;set;}
    public list<sortWrapper> lstadditonalDiagSRT{get;set;}

    //TRP  
    public list<CSS_Solution_Component__c> trpsrtlstUI;
    public list<TRPCompWrapper> listTRPWrapper1 {get;set;}
    public list<TRPsrtWrapper> listTRPsrtWrapper1 {get;set;}
    public void setsVfComp(String argId){
        sVfComp = argId; 
        //System.debug('The value of svfComp is'+sVfComp);

    } 
    public list<CSS_Solution_Component__c> atcsrtlstUI;
    public list<ATCCompWrapper> listatcWrapper {get;set;}
    public list<ATCsrtWrapper> listATCsrtWrapper {get;set;}
    Transient  List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
    public List<CompWrapper> additionalCompWrapper {get;set;}
    public list<srtWrapper> addListsrtWrapper {get;set;}
    public List<trpcompWrapper> additionalTRPWrapper {get;set;}
    public list<trpsrtWrapper> addListTRPsrtWrapper {get;set;}
    public list<ATCCompWrapper> addATCWrapper {get;set;}
    public list<ATCsrtWrapper> addATCsrtWrapper {get;set;}

    public String getsVfComp(){
        return sVfComp; 
    }

    public CG_CL_ClaimsSRTCampaignsController()
    {
        Cid=ApexPages.CurrentPage().getParameters().get('id');

        if(CID != null){
            additionalSRTList  = [select Id,SRT_ID__c ,name,SRT_Category__c,Extended_Hours__c,SRT_Type__c,type__c,Account_Code__c,FailCode__c,Component_Id__c,SRT_Title__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_Time__c,Access_Code__c,CSS_Claims__c,
                                  SRT_Warrantable__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c from CSS_SRT__c where CSS_Claims__c=:CID and SRT_Category__c IN ('Campaign','ATC','TRP')];
        }
        system.debug('*****in CG_CL_ClaimsSRTCampaignsController additionalSRTList>>:'+additionalSRTList);
        getAllCampSrtsData();
        getAllTRPSrtsData();
        getAllATCSrtsData();
    }
    //Wrapper for Sort order for Diagnosis Access SRT. 
    public class sortWrapper implements Comparable{
        public CSS_SRT__c srtRec{get;set;}
        public boolean selectedRecord{get;set;}

        //constructor
        public sortWrapper(CSS_SRT__c srtRec){
            this.srtRec = srtRec;
            this.selectedRecord = false;
        }

        public Integer compareTo(Object ObjToCompare) {
            system.debug('srtRec--->'+srtRec);
            if(srtRec.SRT_Order__c == null){
                if(((sortWrapper)ObjToCompare).srtRec.SRT_Order__c == null)
                    return 0; //equal
                else
                    return -1; // null is before other strings
            }
            else // this.member != null
            {

                if(((sortWrapper)ObjToCompare).srtRec.SRT_Order__c == null)
                    return 1;  // all other strings are after null
                else
                    return integer.valueOf(srtRec.SRT_Order__c - ((sortWrapper)ObjToCompare).srtRec.SRT_Order__c);
            }
        }
    }

    //Method for getting values which job having type is equal to compain in SRT Object
    public void getAllCampSrtsData(){
        listcompWrapper = new List<compWrapper>();
        campsrtlstUI = new list<CSS_Solution_Component__c>();
        totalCampaignSRT = 0.0; //changed
        totalCampaignAccessTime = 0.0; //changed
        try{
            system.debug('in getAllCampSrtsData JobID>>>>>>>>>campParts>:'+Wid+' Cid>>>:'+Cid);
            if(Cid !=null){
                campsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,CSS_Claims__c,CSS_Account_Formula__c,
                                (select Id,SRT_ID__c ,Account_Code__c,FailCode__c,Extended_Hours__c,Component_Id__c,SRT_Title__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_Time__c,Access_Code__c,CSS_Claims__c,
                                 SRT_Warrantable__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c,srt_category__c,type__c from CSS_SRTs__r) 
                                from CSS_Solution_Component__c where Type__c='CAMPAIGN'  and CSS_Claims__c=:Cid
                                and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                           and Multiple_Times__c=false))];
            }
            system.debug('*****in getAllCampSrtsData campsrtlstUI size>>>:'+campsrtlstUI.size()+' Cid22>>>:'+Cid);
            integer Compcount = 0;
            if(campsrtlstUI!=null && campsrtlstUI.size()>0){
                //listcompWrapper = new List<compWrapper>();
                //  CompCountVar = false;
                for(CSS_Solution_Component__c solcomp : campsrtlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        integer srtcount = 0;
                        string percentageCov;
                        listsrtWrapper = new list<srtWrapper>();
                        system.debug('Outsidepartcount*'+srtcount);
                        for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                            srtcount = srtcount + 1;
                            system.debug('Insidepartcount*'+srtcount);
                            if(srts.CSS_Claims__c == solcomp.CSS_Claims__c){
                                //system.debug('solution quantity>>>>>>>>>>>>>>'+solcomp.Quantity__c);
                                //compParts = true;
                                if(solcomp.Id == srts.Component_Id__c){                                    
                                    percentageCov = '100';
                                    listsrtWrapper.add(new srtWrapper(srts.Id,
                                                                      srts.SRT_ID__c,
                                                                      srts.SRT_Title__c,
                                                                      srts.SRT_Quantity__c,
                                                                      String.valueof(srts.Additional_SRT_Calculated__c),
                                                                      srts.SRT_Time__c,
                                                                      srts.Access_Code__c,
                                                                      srts.SRT_Warrantable__c,
                                                                      srts.Adjustment_Reason__c,
                                                                      srts.SRT_Select__c,
                                                                      srtcount,
                                                                      percentageCov,
                                                                      srts.type__c,
                                                                      srts.FailCode__c,
                                                                      srts.Account_Code__c,
                                                                     srts.Extended_Hours__c));
                                }                                
                            }

                            system.debug('listsrtWrapper**'+listsrtWrapper);
                            system.debug('srtselect'+srts.SRT_Select__c);
                            if(srts.SRT_Select__c ==true){
                                if(srts.type__c != 'Field Action Access')
                                    system.debug('srttype'+srts.type__c);
                                // if(srts.type__c=='CAMPAIGN')
                                totalCampaignSRT = totalCampaignSRT+srts.SRT_Time__c;
                                if(srts.type__c == 'Field Action Access')
                                    totalCampaignAccessTime = totalCampaignAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                            }
                        }
                        listcompWrapper.add(new compwrapper(solComp.id,
                                                            solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,
                                                            solcomp.CSS_Account_Formula__c,
                                                            listsrtWrapper,srtcount));
                        system.debug('listcompwrapper**'+listcompwrapper);

                    }                
                }
            }
            //additionalCompWrapper = new CompWrapper();
            additionalCompWrapper = new List<compwrapper>();
            if(additionalSRTList != null){

                addListsrtWrapper = new list<srtWrapper>();
                for(CSS_SRT__c srts : additionalSRTList){
                    system.debug('insidecampaign-srts.SRT_Category__c/AccordionType__c**'+srts.SRT_Category__c);
                    if(srts.SRT_Category__c == 'Campaign'){
                        system.debug('insidecampaign**'+additionalSRTList);
                        addListsrtWrapper.add(new srtWrapper(srts.Id,
                                                             srts.SRT_ID__c,
                                                             srts.SRT_Title__c,
                                                             srts.SRT_Quantity__c,
                                                             String.valueof(srts.Additional_SRT_Calculated__c),
                                                             srts.SRT_Time__c,
                                                             srts.Access_Code__c,
                                                             srts.SRT_Warrantable__c,
                                                             srts.Adjustment_Reason__c,
                                                             true,//srts.SRT_Select__c, //checking by default here
                                                             0,
                                                             '0',
                                                             srts.type__c,
                                                             srts.FailCode__c,
                                                             srts.Account_Code__c,
                                                             srts.Extended_Hours__c));
                    }
                }

            }

            system.debug('addListsrtWrapper**'+addListsrtWrapper);

            /*if(addListsrtWrapper!=null && addListsrtWrapper.size()>0){
            additionalCompWrapper.srtWrapper =  addListsrtWrapper; 
            }*/
            additionalCompWrapper.add(new compwrapper(null,
                                                      'Additional SRTs',
                                                      null,
                                                      addListsrtWrapper,0));

            system.debug('additionalCompWrapper**'+additionalCompWrapper);
        }
        catch(Exception ex){
            System.debug('in catch of CampSrtsData of CSS_SRT__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //Method for getting values which job having type is equal to TRP in SRT Object
    public void getAllTRPSrtsData(){
        TrpsrtlstUI = new list<CSS_Solution_Component__c>();
        totalTRPSRT = 0.0;
        totalTRPAccessTime = 0.0;
        try{
            system.debug('JobID>>>>>>>>>campParts>:'+Wid);
            if(Cid !=null){
                TrpsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,CSS_Claims__c,CSS_Account_Formula__c,
                               (select Id,SRT_ID__c ,Component_Id__c,SRT_Title__c,Extended_Hours__c,Account_Code__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_Time__c,Access_Code__c,CSS_Claims__c,
                                SRT_Warrantable__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c,type__c,FailCode__c from CSS_SRTs__r) 
                               from CSS_Solution_Component__c where Type__c='TRP' and CSS_Claims__c=:Cid 
                               and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                 and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            }
            integer Compcount = 0;
            if(TrpsrtlstUI!=null && TrpsrtlstUI.size()>0){
                //listtrpWrapper = new List<compWrapper>();
                listTRPWrapper1 = new List<trpcompWrapper>();
                //  CompCountVar = false;
                system.debug('TrpsrtlstUI:'+TrpsrtlstUI);
                for(CSS_Solution_Component__c solcomp : TrpsrtlstUI){
                    if(solcomp != null){
                        //CompCountVar = true;
                        Compcount = Compcount + 1;
                        integer trpsrtcount = 0;
                        string percentageCov;
                        listTRPsrtWrapper1 = new list<trpsrtWrapper>();
                        system.debug('Outsidepartcount*'+trpsrtcount);
                        system.debug('Value:-'+solcomp.CSS_SRTs__r);
                        for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                            trpsrtcount = trpsrtcount + 1;
                            system.debug('Insidepartcount*'+trpsrtcount);
                            system.debug('solcomp.Id*'+solcomp.Id);
                            system.debug('srts.Component_Id__c*'+srts.Component_Id__c);
                            if(srts.CSS_Claims__c == solcomp.CSS_Claims__c){
                                if(solcomp.Id == srts.Component_Id__c){                                    
                                    percentageCov = '100';
                                    listTRPsrtWrapper1.add(new TRPsrtWrapper(srts.Id,
                                                                             srts.SRT_ID__c,
                                                                             srts.SRT_Title__c,
                                                                             srts.SRT_Quantity__c,
                                                                             String.valueof(srts.Additional_SRT_Calculated__c),
                                                                             srts.SRT_Time__c,
                                                                             srts.Access_Code__c,
                                                                             srts.SRT_Warrantable__c,
                                                                             srts.Adjustment_Reason__c,
                                                                             srts.SRT_Select__c,
                                                                             trpsrtcount,
                                                                             percentageCov,
                                                                             srts.type__c,
                                                                             srts.FailCode__c,
                                                                             srts.Account_Code__c,
                                                                             srts.Extended_Hours__c));
                                }                                
                            }

                            system.debug('listTRPsrtWrapper**'+listTRPsrtWrapper1);
                            if(srts.SRT_Select__c ==true){
                                if(srts.type__c != 'Field Action Access')
                                    totalTRPSRT = totalTRPSRT+srts.SRT_Time__c;
                                system.debug('totalTRPSRT'+totalTRPSRT);
                                if(srts.type__c == 'Field Action Access')
                                    totalTRPAccessTime = totalTRPAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                                system.debug('totalTRPAccessTime'+totalTRPAccessTime);
                            }
                        }
                        listTRPWrapper1.add(new TRPCompWrapper(solComp.id,
                                                               solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,
                                                               solcomp.CSS_Account_Formula__c,
                                                               listTRPsrtWrapper1,
                                                               trpsrtcount));
                        system.debug('listtrpwrapper**'+listTRPWrapper1);
                    }                
                }
            }

            additionalTRPWrapper = new List<trpcompWrapper>();
            if(additionalSRTList != null){

                addListTRPsrtWrapper = new list<trpsrtWrapper>();
                for(CSS_SRT__c srts : additionalSRTList){
                    system.debug('insideTRP-srts.SRT_Category__c/AccordionType__c**'+srts.SRT_Category__c);
                    if(srts.SRT_Category__c == 'TRP'){
                        system.debug('insidecampaign**'+additionalSRTList);
                        addListTRPsrtWrapper.add(new trpsrtWrapper(srts.Id,
                                                                   srts.SRT_ID__c,
                                                                   srts.SRT_Title__c,
                                                                   srts.SRT_Quantity__c,
                                                                   String.valueof(srts.Additional_SRT_Calculated__c),
                                                                   srts.SRT_Time__c,
                                                                   srts.Access_Code__c,
                                                                   srts.SRT_Warrantable__c,
                                                                   srts.Adjustment_Reason__c,
                                                                   true,//srts.SRT_Select__c, //checking by default here
                                                                   0,
                                                                   '0',
                                                                   srts.type__c,
                                                                   srts.FailCode__c,
                                                                   srts.Account_Code__c,
                                                                   srts.Extended_Hours__c));
                    }
                }

            }

            system.debug('addListTRPsrtWrapper**'+addListTRPsrtWrapper);

            /*if(addListsrtWrapper!=null && addListsrtWrapper.size()>0){
            additionalCompWrapper.srtWrapper =  addListsrtWrapper; 
            }*/
            additionalTRPWrapper.add(new trpcompWrapper(null,
                                                        'Additional SRTs',
                                                        null,
                                                        addListTRPsrtWrapper,0));

            system.debug('addListTRPsrtWrapper**'+addListTRPsrtWrapper);
        }
        catch(Exception ex){
            System.debug('in catch of CampSrtsData of CSS_SRT__c with Solution Component>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //Method for getting values which job having type is equal to ATC in SRT Object
    public void getAllATCSrtsData(){
        atcsrtlstUI = new list<CSS_Solution_Component__c>();
        totalATCSRT=0.0;
        totalATCAccessTime=0.0;
        //try{
        system.debug('JobID>>>>>>>>>campParts>:'+Wid);
        if(Cid !=null){
            atcsrtlstUI = [select Id,Type__c,Component_Id__c,Campaign_Description__c,Service_Job__c,CSS_Claims__c,CSS_Account_Formula__c,
                           (select Id,SRT_ID__c ,Component_Id__c,Extended_Hours__c,SRT_Title__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_Time__c,Access_Code__c,CSS_Claims__c,
                            SRT_Warrantable__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c,type__C,FailCode__c,Account_Code__c from CSS_SRTs__r) 
                           from CSS_Solution_Component__c where Type__c='ATC' and CSS_Claims__c =:Cid 
                           and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false 
                           and Multiple_Times__c=false))];
        }
        system.debug('****atcsrtlstUI****'+atcsrtlstUI);
        integer Compcount = 0;
        if(atcsrtlstUI!=null && atcsrtlstUI.size()>0){
            listatcWrapper = new List<ATCCompWrapper>();
            //  CompCountVar = false;
            for(CSS_Solution_Component__c solcomp : atcsrtlstUI){
                if(solcomp != null){
                    //CompCountVar = true;
                    Compcount = Compcount + 1;
                    integer atcsrtcount = 0;
                    string percentageCov = '100';
                    listatcsrtWrapper = new list<atcsrtWrapper>();
                    system.debug('Outsidepartcount*'+atcsrtcount);
                    for(CSS_SRT__c srts : solcomp.CSS_SRTs__r){
                        atcsrtcount = atcsrtcount + 1;
                        system.debug('Insidepartcount*'+atcsrtcount);
                        if(srts.CSS_Claims__c == solcomp.CSS_Claims__c){
                            if(solcomp.Id == srts.Component_Id__c){                                    
                                //percentageCov = '100'; 
                                /*if(srts.SRT_Hours_Percentage__c==null && srts.SRT_Hours_Percentage__c==0)                                  
                                    percentageCov ='100';
                                else  
                                    percentageCov = String.valueof(srts.SRT_Hours_Percentage__c);*/
                                percentageCov = srts.SRT_Warrantable__c;
                                listatcsrtWrapper.add(new atcsrtWrapper(srts.Id,
                                                                        srts.SRT_ID__c,
                                                                        srts.SRT_Title__c,
                                                                        srts.SRT_Quantity__c,
                                                                        String.valueof(srts.Additional_SRT_Calculated__c),
                                                                        srts.SRT_Time__c,
                                                                        srts.Access_Code__c,
                                                                        percentageCov,
                                                                        srts.Adjustment_Reason__c,
                                                                        srts.SRT_Select__c,
                                                                        atcsrtcount,
                                                                        percentageCov,
                                                                        srts.type__c,                                                                       
                                                                        srts.FailCode__c,
                                                                        srts.Account_Code__c,
                                                                        srts.Extended_Hours__c));
                            }                                
                        }

                        system.debug('listatcsrtWrapper**'+listatcsrtWrapper);
                        if(srts.SRT_Select__c ==true){
                            if(srts.type__c != 'Field Action Access')
                                totalATCSRT = totalATCSRT+srts.SRT_Time__c;
                            if(srts.type__c == 'Field Action Access')
                                totalATCAccessTime = totalATCAccessTime+(srts.SRT_Quantity__c*srts.SRT_Time__c);
                        }
                    }
                    listatcwrapper.add(new ATCCompWrapper(solComp.id,
                                                          solcomp.Component_Id__c+'-'+solcomp.Campaign_Description__c,
                                                          solcomp.CSS_Account_Formula__c,
                                                          listatcsrtWrapper,
                                                          atcsrtcount));
                    system.debug('listatcwrapper**'+listatcwrapper);
                }                
            }
        }
        addATCWrapper = new List<ATCCompWrapper>();
            if(additionalSRTList != null){

                addATCsrtWrapper = new list<ATCsrtWrapper>();
                for(CSS_SRT__c srts : additionalSRTList){
                    system.debug('insidecampaign-srts.SRT_Category__c/AccordionType__c**'+srts.SRT_Category__c);
                    if(srts.SRT_Category__c == 'ATC'){
                        system.debug('insidecampaign**'+additionalSRTList);
                        addATCsrtWrapper.add(new ATCsrtWrapper(srts.Id,
                                                             srts.SRT_ID__c,
                                                             srts.SRT_Title__c,
                                                             srts.SRT_Quantity__c,
                                                             String.valueof(srts.Additional_SRT_Calculated__c),
                                                             srts.SRT_Time__c,
                                                             srts.Access_Code__c,
                                                             srts.SRT_Warrantable__c,
                                                             srts.Adjustment_Reason__c,
                                                             true,//srts.SRT_Select__c, //checking by default here
                                                             0,
                                                             '0',
                                                             srts.type__c,
                                                             srts.FailCode__c,
                                                             srts.Account_Code__c,
                                                             srts.Extended_Hours__c));
                    }
                }

            }

            system.debug('addATCsrtWrapper**'+addATCsrtWrapper);

            /*if(addListsrtWrapper!=null && addListsrtWrapper.size()>0){
            additionalCompWrapper.srtWrapper =  addListsrtWrapper; 
            }*/
            addATCWrapper.add(new ATCCompWrapper(null,
                                                'Additional SRTs',
                                                null,
                                                addATCsrtWrapper,0));

            system.debug('addATCWrapper**'+addATCWrapper);
    }



    //wrapper classes for COMPONENT and SRT when type is equal to CAMPAIGN
    public class CompWrapper{
        public Id CompIds {get;set;}
        public string FieldActNum {get;set;}
        public string accNumber {get;set;}
        public list<srtWrapper> srtWrapper {get;set;}
        public integer srtcount{get;set;}
        public CompWrapper(Id CompIds,string FieldActNum,string accNumber,list<srtWrapper> srtWrapper,integer srtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.accNumber = accNumber;
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
        public integer srtcount{get;set;}
        public String percentage{get;set;} 
        public String type{get;set;} 
        public String failCode{get;set;} 
        public String accCode{get;set;} 
        public list<sortWrapper> lstDiagWrapSRT{get;set;}
        public list<sortWrapper> lstadditonalDiagSRT{get;set;}
        public decimal ClaimedHrs{get;set;}
        public srtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedcomponent,integer srtcount,String percentage,String type,String failCode,String accCode,decimal ClaimedHrs) {

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
            this.srtcount = srtcount;
            this.percentage = percentage;
            this.type = type;
            this.failCode = failCode;
            this.accCode = accCode;
            lstDiagWrapSRT = new list<sortWrapper>();
            lstadditonalDiagSRT = new list<sortWrapper>();
this.ClaimedHrs = ClaimedHrs;
        }       
    }
    //wrapper class for TRP and Comp
    public class TRPCompWrapper{
        public Id CompIds {get;set;}
        public string FieldActNum {get;set;}
        public string accNumber {get;set;}
        public list<TRPsrtWrapper> TRPsrtWrapper {get;set;}
        public integer trpsrtcount{get;set;}
        public TRPCompWrapper(Id CompIds,string FieldActNum,string accNumber,list<TRPsrtWrapper> TRPsrtWrapper,integer trpsrtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.accNumber = accNumber;
            this.TRPsrtWrapper = TRPsrtWrapper;
            this.trpsrtcount = trpsrtcount;
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
        public integer trpsrtcount{get;set;}
        public String percentage{get;set;} 
        public String type{get;set;}  
        public String failCode{get;set;} 
        public String accCode{get;set;}
        public list<sortWrapper> lstTRPWrapSRT{get;set;}
        public decimal ClaimedHrs{get;set;}

        public TRPsrtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedcomponent,integer trpsrtcount,String percentage,String type,String failCode,String accCode,decimal ClaimedHrs) {

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
            this.trpsrtcount = trpsrtcount;
            this.percentage = percentage;
            this.type = type;
            this.failCode = failCode;
            this.accCode = accCode;

            lstTRPWrapSRT = new list<sortWrapper>();
            this.ClaimedHrs = ClaimedHrs;

        }

    }
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
        public integer atcsrtcount{get;set;}
        public String percentage{get;set;} 
        public String type{get;set;}  
        public String failCode{get;set;} 
        public String accCode{get;set;}
public decimal ClaimedHrs{get;set;}

        public ATCsrtWrapper(Id srtids,String SRTCode,String SRTDescription,Decimal quantity,String ACCESSSRTTime,Decimal SRTTime,String AccessCode,String SRTHours,String AdjustmentReason,Boolean selectedcomponent,integer atcsrtcount,String percentage,String type,String failCode,String accCode,decimal ClaimedHrs) {

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
            this.atcsrtcount = atcsrtcount;
            this.percentage = percentage;
            this.type = type;
            this.failCode = failCode;
            this.accCode = accCode;
this.ClaimedHrs = ClaimedHrs;

        }

    }
    public class ATCCompWrapper{
        public Id CompIds {get;set;}
        public string FieldActNum {get;set;}
        public string accNumber {get;set;}
        public list<ATCsrtWrapper> ATCsrtWrapper {get;set;}
        public integer atcsrtcount{get;set;}
        public ATCCompWrapper(Id CompIds,string FieldActNum,string accNumber,list<atcsrtWrapper> atcsrtWrapper,integer atcsrtcount){
            this.CompIds= CompIds;
            this.FieldActNum = FieldActNum;
            this.accNumber = accNumber;
            this.atcsrtWrapper = atcsrtWrapper;
            this.atcsrtcount = atcsrtcount;
        }
    }
    public void changeDownOrdertrp(){

        for(TRPsrtWrapper srtWrap : listTRPsrtWrapper1){
            system.debug('Agassi sor Akhil>>>>>>>' +listTRPsrtWrapper1);
            integer i = 0;
            system.debug('Agassi sor wrap>>>>>>>' +srtWrap.lstTRPWrapSRT);
            for(sortWrapper sortwrp : srtWrap.lstTRPWrapSRT){
                if(sortwrp.selectedRecord){
                    system.debug('Selected value Akhil'+ sortwrp.selectedRecord);
                    decimal temp;
                    if(i < srtWrap.lstTRPWrapSRT.size()-1){
                        temp = sortwrp.srtRec.SRT_Order__c;
                        sortwrp.srtRec.SRT_Order__c = srtWrap.lstTRPWrapSRT[i+1].srtRec.SRT_Order__c;
                        srtWrap.lstTRPWrapSRT[i+1].srtRec.SRT_Order__c = temp;
                    }

                }
                i=i+1;
            }
            srtWrap.lstTRPWrapSRT.sort();
        }
    }
    public void changeUpOrder(){
        list<css_srt__c> updateSortSRTs = new list <css_srt__c>();
        for(srtWrapper srtWrap : diagListWrap){
            integer i = 0;
            system.debug('Anirudh sort wrap>>>>>>'+srtWrap.lstDiagWrapSRT);
            for(sortWrapper sortwrp : srtWrap.lstDiagWrapSRT){

                if(sortwrp.selectedRecord){
                    decimal temp;
                    if(i != 0){
                        temp = sortwrp.srtRec.SRT_Order__c;
                        sortwrp.srtRec.SRT_Order__c = srtWrap.lstDiagWrapSRT[i-1].srtRec.SRT_Order__c;
                        srtWrap.lstDiagWrapSRT[i-1].srtRec.SRT_Order__c = temp;
                    }

                }
                i=i+1;
                //updateSortSRTs.add();
            }
            srtWrap.lstDiagWrapSRT.sort();
            // system.debug('Anirudh updateSortSRTs>>>>>>>'+srtWrap); 
        }
        //system.debug('Anirudh updateSortSRTs>>>>>>>'+srtWrap);

        //Shuffeling the order for Additional SRT
        if(additionalDiagListWrap != null && additionalDiagListWrap.size() > 0){
            for(srtWrapper addsrtWrap : additionalDiagListWrap){
                integer i = 0;
                for(sortWrapper addsortwrp : addsrtWrap.lstadditonalDiagSRT){
                    if(addsortwrp.selectedRecord){
                        decimal temp;
                        if(i != 0){
                            temp = addsortwrp.srtRec.SRT_Order__c;
                            addsortwrp.srtRec.SRT_Order__c = addsrtWrap.lstadditonalDiagSRT[i-1].srtRec.SRT_Order__c;
                            addsrtWrap.lstadditonalDiagSRT[i-1].srtRec.SRT_Order__c = temp;
                        }

                    }
                    i=i+1;
                }
                addsrtWrap.lstadditonalDiagSRT.sort();
            }
        }
        //saveDiagData();
    }
    public void changeDownOrder(){

        for(TRPsrtWrapper srtWrap : listTRPsrtWrapper1){
            integer i = 0;
            system.debug('Agassi sor wrap>>>>>>>' +srtWrap.lstTRPWrapSRT);
            for(sortWrapper sortwrp : srtWrap.lstTRPWrapSRT){
                if(sortwrp.selectedRecord){
                    system.debug('Selected value Akhil'+ sortwrp.selectedRecord);
                    decimal temp;
                    if(i < srtWrap.lstTRPWrapSRT.size()-1){
                        temp = sortwrp.srtRec.SRT_Order__c;
                        sortwrp.srtRec.SRT_Order__c = srtWrap.lstTRPWrapSRT[i+1].srtRec.SRT_Order__c;
                        srtWrap.lstTRPWrapSRT[i+1].srtRec.SRT_Order__c = temp;
                    }

                }
                i=i+1;
            }
            srtWrap.lstTRPWrapSRT.sort();
        }

        //Shuffeling the order for Additional SRT
        /*if(additionalDiagListWrap != null && additionalDiagListWrap.size() > 0){
            for(srtWrapper addsrtWrap : additionalDiagListWrap){
                integer i = 0;
                for(sortWrapper addsortwrp : addsrtWrap.lstadditonalDiagSRT){
                    if(addsortwrp.selectedRecord){
                        decimal temp;
                        if(i < addsrtWrap.lstadditonalDiagSRT.size()-1){
                            temp = addsortwrp.srtRec.SRT_Order__c;
                            addsortwrp.srtRec.SRT_Order__c = addsrtWrap.lstadditonalDiagSRT[i+1].srtRec.SRT_Order__c;
                            addsrtWrap.lstadditonalDiagSRT[i+1].srtRec.SRT_Order__c = temp;
                        }

                    }
                    i=i+1;
                }
                addsrtWrap.lstadditonalDiagSRT.sort();
            }
        }*/
        //saveDiagData();

    }
    
    public pageReference saveCampTRPATCData(){
        try{
            PageReference pageRef;
            Transient list<CSS_SRT__c> updateCampSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateAddCampSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateTRPSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateAddTRPSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateATCSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateATCRepSRTList = new list<CSS_SRT__c>();
            if(listcompWrapper != null){
                for(CompWrapper s:listcompWrapper){
                    for(srtWrapper c:s.srtWrapper){
                        CSS_SRT__c srtObj = new CSS_SRT__c();
                        srtObj.Id = c.srtids;
                        srtObj.SRT_ID__c = c.SRTCode;
                        srtObj.SRT_Title__c = c.SRTDescription;
                        srtObj.SRT_Quantity__c = c.quantity;
                        srtObj.SRT_Time__c = c.SRTTime;
                        srtObj.Access_Code__c = c.AccessCode;
                        srtObj.Adjustment_Reason__c = c.AdjustmentReason;
                        srtObj.SRT_Select__c = c.selectedcomponent;
                        srtObj.type__c = c.type;
                        srtObj.FailCode__c = c.failCode;
                        srtObj.Account_Code__c = c.accCode;
                        updateCampSRTList.add(srtObj);
                    }

                }
                
            }
            if(updateCampSRTList!= null && !updateCampSRTList.isEmpty()){
                update  updateCampSRTList;
            }
            
            if(additionalCompWrapper != null){
                for(CompWrapper s:additionalCompWrapper){
                        for(srtWrapper c:s.srtWrapper){
                            CSS_SRT__c srtObj = new CSS_SRT__c();
                            srtObj.Id = c.srtids;
                            srtObj.SRT_ID__c = c.SRTCode;
                            srtObj.SRT_Title__c = c.SRTDescription;
                            srtObj.SRT_Quantity__c = c.quantity;
                            srtObj.SRT_Time__c = c.SRTTime;
                            srtObj.Access_Code__c = c.AccessCode;
                            srtObj.Adjustment_Reason__c = c.AdjustmentReason;
                            srtObj.SRT_Select__c = c.selectedcomponent;
                            srtObj.type__c = c.type;
                            srtObj.FailCode__c = c.failCode;
                            srtObj.Account_Code__c = c.accCode;
                            updateAddCampSRTList.add(srtObj);
                        } 
                }
            }
            if(updateAddCampSRTList != null && !updateAddCampSRTList.isEmpty()){
                update updateAddCampSRTList;
            }
            
            if(listTRPWrapper1 != null){
            for(TRPCompWrapper s:listTRPWrapper1){
                    for(TRPsrtWrapper c:s.TRPsrtWrapper){
                        CSS_SRT__c srtObj = new CSS_SRT__c();
                        srtObj.Id = c.srtids;
                        srtObj.SRT_ID__c = c.SRTCode;
                        srtObj.SRT_Title__c = c.SRTDescription;
                        srtObj.SRT_Quantity__c = c.quantity;
                        srtObj.SRT_Time__c = c.SRTTime;
                        srtObj.Access_Code__c = c.AccessCode;
                        srtObj.Adjustment_Reason__c = c.AdjustmentReason;
                        srtObj.SRT_Select__c = c.selectedcomponent;
                        srtObj.type__c = c.type;
                        srtObj.FailCode__c = c.failCode;
                        srtObj.Account_Code__c = c.accCode;
                        updateTRPSRTList.add(srtObj);
                    }

                }    
            }
            
            if(updateTRPSRTList != null && !updateTRPSRTList.isEmpty()){
                update updateTRPSRTList;
            }
            
            if(additionalTRPWrapper != null){
                for(TRPCompWrapper s:additionalTRPWrapper){
                    for(TRPsrtWrapper c:s.TRPsrtWrapper){
                        CSS_SRT__c srtObj = new CSS_SRT__c();
                        srtObj.Id = c.srtids;
                        srtObj.SRT_ID__c = c.SRTCode;
                        srtObj.SRT_Title__c = c.SRTDescription;
                        srtObj.SRT_Quantity__c = c.quantity;
                        srtObj.SRT_Time__c = c.SRTTime;
                        srtObj.Access_Code__c = c.AccessCode;
                        srtObj.Adjustment_Reason__c = c.AdjustmentReason;
                        srtObj.SRT_Select__c = c.selectedcomponent;
                        srtObj.type__c = c.type;
                        srtObj.FailCode__c = c.failCode;
                        srtObj.Account_Code__c = c.accCode;
                        updateAddTRPSRTList.add(srtObj);
                    }

                }
            }
            if(updateAddTRPSRTList != null && !updateAddTRPSRTList.isEmpty()){
                update updateAddTRPSRTList;
            }
            
            if(listatcWrapper != null){
                for(ATCCompWrapper s:listatcWrapper){
                    for(ATCsrtWrapper c:s.ATCsrtWrapper){
                        CSS_SRT__c srtObj = new CSS_SRT__c();
                        srtObj.Id = c.srtids;
                        srtObj.SRT_ID__c = c.SRTCode;
                        srtObj.SRT_Title__c = c.SRTDescription;
                        srtObj.SRT_Quantity__c = c.quantity;
                        srtObj.SRT_Time__c = c.SRTTime;
                        srtObj.Access_Code__c = c.AccessCode;
                        srtObj.Adjustment_Reason__c = c.AdjustmentReason;
                        srtObj.SRT_Select__c = c.selectedcomponent;
                        srtObj.type__c = c.type;
                        srtObj.FailCode__c = c.failCode;
                        srtObj.Account_Code__c = c.accCode;
                        updateATCSRTList.add(srtObj);
                    }

                }
            }
            if(updateATCSRTList != null && !updateATCSRTList.isEmpty()){
                update updateATCSRTList;
            }
            if(addATCWrapper != null){
                for(ATCCompWrapper s:addATCWrapper){
                    for(ATCsrtWrapper c:s.ATCsrtWrapper){
                        CSS_SRT__c srtObj = new CSS_SRT__c();
                        srtObj.Id = c.srtids;
                        srtObj.SRT_ID__c = c.SRTCode;
                        srtObj.SRT_Title__c = c.SRTDescription;
                        srtObj.SRT_Quantity__c = c.quantity;
                        srtObj.SRT_Time__c = c.SRTTime;
                        srtObj.Access_Code__c = c.AccessCode;
                        srtObj.Adjustment_Reason__c = c.AdjustmentReason;
                        srtObj.SRT_Select__c = c.selectedcomponent;
                        srtObj.type__c = c.type;
                        srtObj.FailCode__c = c.failCode;
                        srtObj.Account_Code__c = c.accCode;
                        updateATCRepSRTList.add(srtObj);
                    }

                }
            }
            if(updateATCRepSRTList != null && !updateATCRepSRTList.isEmpty()){
                update updateATCRepSRTList;
            }
            

            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            pageRef = new PageReference(sDestURL+'id='+CID); 
            pageRef.setRedirect(true);
            return pageRef;
        }catch(exception e){
            system.debug('Entered into saveCAmpTRPATCdata method of cg_cl_claimsSRTCampaignscontroller class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        return null;

    }
    
    public void resetUpdatedCampTRPATCData(){
        system.debug('inside resetUpdatedCampTRPATCData');
        getAllCampSrtsData();
        getAllTRPSrtsData();
        getAllATCSrtsData();
        
    }



}