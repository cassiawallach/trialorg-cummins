public class CSS_OverlapSRT {
    //Class Variables
    public Id pgId{get;set;}  
    //public CSS_Job_Order__c serviceJob{get; set;}   
    //CSS_OverlapSRTReq overlapSRTREq; 
    //public String overlapErrorMsg{set;get;}
    //public integer timemin{set;get;}
    //public integer timeminov{set;get;}
    public Double TotalOverlapHours{set;get;}
    public List<overLapSrtWrapper> lstOverlapSRTWrapper {get;set;} 
    public List<overLapSrtSubWrapper> lstOverlapsubSRTWrapper {get;set;} 
    public List<overLapSrtSubWrapper> lstOverlapsubSRTWrapperTemp {get;set;} 
    public String selectedSRT{get;set;}
    public Boolean isOverride{get;set;}
    public String selectedAcCode{get;set;}
    public double totalHrs{get;set;}
    public Map<String,List<overLapSrtWrapper>> accountCodeWithOverlapMap{get;set;}
    public Boolean errorMsgFlag{get;set;}
    //public Double TotalAdjustedHours{set;get;}
    public String EquipId{get; set;} // Story GSSC-289
    public list<overLapSrtWrapper> lstOverLapSrt{get;set;}//s-109748
    public map<string,CSS_SRT__c> mapStepIdtoSrt;
    public set<string> setSRTCode;
    public List<CSS_SRT__c> lstExistingOverlapSrt;
    map<string,CSS_SRT__C> mapSRTcodetoSRT = new map<string,CSS_SRT__C>();

    //List<AggregateResult> lstSRT = new List<AggregateResult>();
    List<CSS_SRT__C> lstSRT = new List<CSS_SRT__C>();

    
    //Constructor
    public CSS_OverlapSRT(){
        errorMsgFlag = false;
        TotalOverlapHours = 0.0;
        totalHrs = 0.0;
        accountCodeWithOverlapMap = new Map<String,List<overLapSrtWrapper>>();
        pgId = ApexPages.CurrentPage().getParameters().get('id');
        loadOverlapSRTs();
    }
    
    public void loadOverlapSRTs(){
        System.debug('in loadOverlapSRTs...');
        try{
            accountCodeWithOverlapMap = new Map<String,List<overLapSrtWrapper>>(); //newely added
            lstOverlapSRTWrapper = new List<overLapSrtWrapper>();
            lstOverlapsubSRTWrapper = new List<overLapSrtSubWrapper>();
            lstOverlapsubSRTWrapperTemp = new List<overLapSrtSubWrapper>();

            //Map<String, List<overLapSrtSubWrapper>> subSRTWrapperMap = new Map<String, List<overLapSrtSubWrapper>>();
            //Set<String> accountCodes = new Set<String>();

            Boolean isDiffRecord;
            String tempAccountCode;
            lstSRT = new List<CSS_SRT__c>([select Id,Name,Overlap_SRT_Number__c,SRT_ID__c,Overlap_Hours__c,Override__c,Adjusted_Overlap_Hours__c,Account_Code__c, OverrideReason__c,Override_Reason__c,SRT_Title__c,step_id__c,Overlap_Step_Id__c,Overlap_SRT_Title__c from CSS_SRT__c where Job_Order__c =: pgId and Type__c ='Overlap' order by SRT_ID__c desc]);

            //new logic
            if(lstSRT != null && lstSRT.size() > 0){
                for(integer i=0;i<lstSRT.size();i++){
                    if(lstSRT[i].Account_Code__c==null){
                        tempAccountCode = 'Customer Billable';    
                    }else{
                        tempAccountCode =lstSRT[i].Account_Code__c; 
                    }

                    System.debug('I Value$$$>:'+i+' AcCode>>:'+lstSRT[i].Account_Code__c+' SRT_ID>>:'+lstSRT[i].SRT_ID__c+' Overlap SRT_ID>>:'+lstSRT[i].Overlap_SRT_Number__c);
                    if(accountCodeWithOverlapMap !=null && accountCodeWithOverlapMap.containsKey(tempAccountCode)){
                        System.debug('Exists I Value$$$>:'+i+' AcCode>>:'+lstSRT[i].Account_Code__c+' SRT_ID>>:'+lstSRT[i].SRT_ID__c+' Overlap SRT_ID>>:'+lstSRT[i].Overlap_SRT_Number__c);
                        List<overLapSrtWrapper> lstOverlapSRTWrapper1 = accountCodeWithOverlapMap.get(tempAccountCode);
                        Boolean overlapSRTExist = false;
                        for(overLapSrtWrapper overlapSRTWrapTemp : lstOverlapSRTWrapper1){
                            if(lstSRT[i].SRT_ID__c == overlapSRTWrapTemp.SRT_Code ){
                                System.debug('Matched I Value$$$>:'+i+' AcCode>>:'+lstSRT[i].Account_Code__c+' SRT_ID>>:'+lstSRT[i].SRT_ID__c+' Overlap SRT_ID>>:'+lstSRT[i].Overlap_SRT_Number__c);
                                //Mandatory  fields logic
                                Boolean adjHrsFlg = false;
                                Boolean notesFlg = false;
                                Boolean overrideReasonFlg = false;
                                if(lstSRT[i].Override__c){
                                    if(lstSRT[i].Adjusted_Overlap_Hours__c==null)
                                        adjHrsFlg = true;
                                    if(lstSRT[i].OverrideReason__c==null || lstSRT[i].OverrideReason__c.trim()=='')
                                        notesFlg = true;
                                    if(lstSRT[i].Override_Reason__c==null || lstSRT[i].Override_Reason__c=='Select One' || lstSRT[i].Override_Reason__c.trim()=='')
                                        overrideReasonFlg = true;
                                    if(adjHrsFlg || notesFlg || overrideReasonFlg)
                                        errorMsgFlag = true;
                                }
                                overlapSRTWrapTemp.subSRTWrapper.add(new overLapSrtSubWrapper(lstSRT[i].Overlap_SRT_Number__c,lstSRT[i].Overlap_Hours__c,lstSRT[i].Override__c,String.valueof(lstSRT[i].Adjusted_Overlap_Hours__c),lstSRT[i].OverrideReason__c,lstSRT[i].Id,lstSRT[i].Override__c,lstSRT[i].Override_Reason__c,adjHrsFlg,notesFlg,overrideReasonFlg,i,lstSRT[i].Overlap_SRT_Title__c,String.valueof(lstSRT[i].Overlap_Step_Id__c)));
                                //List<overLapSrtSubWrapper> lstOverlapSubSRTWrapper1 = overlapSRTWrapTemp.subSRTWrapper;
                                //lstOverlapSubSRTWrapper1.add(new overLapSrtSubWrapper(lstSRT[i].SRT_ID__c,lstSRT[i].Overlap_Hours__c,lstSRT[i].Override__c,lstSRT[i].Adjusted_Overlap_Hours__c,lstSRT[i].OverrideReason__c,lstSRT[i].Id,lstSRT[i].Override__c,i));
                                overlapSRTExist = true;
                                break;
                            }
                        }
                        if(!overlapSRTExist){
                            System.debug('Not Matched I Value$$$>:'+i+' AcCode>>:'+lstSRT[i].Account_Code__c+' SRT_ID>>:'+lstSRT[i].SRT_ID__c+' Overlap SRT_ID>>:'+lstSRT[i].Overlap_SRT_Number__c);
                            //Mandatory  fields logic
                            Boolean adjHrsFlg = false;
                            Boolean notesFlg = false;
                            Boolean overrideReasonFlg = false;
                            if(lstSRT[i].Override__c){
                                if(lstSRT[i].Adjusted_Overlap_Hours__c==null)
                                    adjHrsFlg = true;
                                if(lstSRT[i].OverrideReason__c==null || lstSRT[i].OverrideReason__c.trim()=='')
                                    notesFlg = true;
                                if(lstSRT[i].Override_Reason__c==null || lstSRT[i].Override_Reason__c=='Select One' || lstSRT[i].Override_Reason__c.trim()=='')
                                    overrideReasonFlg = true;
                                if(adjHrsFlg || notesFlg || overrideReasonFlg)
                                    errorMsgFlag = true;
                            }
                            lstOverlapsubSRTWrapper = new List<overLapSrtSubWrapper>();
                            lstOverlapsubSRTWrapper.add(new overLapSrtSubWrapper(lstSRT[i].Overlap_SRT_Number__c,lstSRT[i].Overlap_Hours__c,lstSRT[i].Override__c,String.valueof(lstSRT[i].Adjusted_Overlap_Hours__c),lstSRT[i].OverrideReason__c,lstSRT[i].Id,lstSRT[i].Override__c,lstSRT[i].Override_Reason__c,adjHrsFlg,notesFlg,overrideReasonFlg,i,lstSRT[i].Overlap_SRT_Title__c,String.valueof(lstSRT[i].Overlap_Step_Id__c)));
                            lstOverlapSRTWrapper1.add(new overLapSrtWrapper(lstSRT[i].SRT_ID__c,tempAccountCode,lstOverlapsubSRTWrapper,lstSRT[i].SRT_Title__c,String.valueof(lstSRT[i].Step_Id__c)));
                        }
                        system.debug('Exists accountCodeWithOverlapMap-->'+accountCodeWithOverlapMap);

                    }else{
                        System.debug('ELSE I Value$$$>:'+i+' AcCode>>:'+lstSRT[i].Account_Code__c+' SRT_ID>>:'+lstSRT[i].SRT_ID__c+' Overlap SRT_ID>>:'+lstSRT[i].Overlap_SRT_Number__c);
                        //subSRTWrapperMap = new Map<String, List<overLapSrtSubWrapper>>();
                        Boolean adjHrsFlg = false;
                        Boolean notesFlg = false;
                        Boolean overrideReasonFlg = false;
                        if(lstSRT[i].Override__c){
                            if(lstSRT[i].Adjusted_Overlap_Hours__c==null)
                                adjHrsFlg = true;
                            if(lstSRT[i].OverrideReason__c==null || lstSRT[i].OverrideReason__c.trim()=='')
                                notesFlg = true;
                            if(lstSRT[i].Override_Reason__c==null || lstSRT[i].Override_Reason__c=='Select One' || lstSRT[i].Override_Reason__c.trim()=='')
                                overrideReasonFlg = true;
                            if(adjHrsFlg || notesFlg || overrideReasonFlg)
                                errorMsgFlag = true;
                        }
                        lstOverlapSRTWrapper = new List<overLapSrtWrapper>();
                        lstOverlapsubSRTWrapper = new List<overLapSrtSubWrapper>();
                        lstOverlapsubSRTWrapper.add(new overLapSrtSubWrapper(lstSRT[i].Overlap_SRT_Number__c,lstSRT[i].Overlap_Hours__c,lstSRT[i].Override__c,String.valueof(lstSRT[i].Adjusted_Overlap_Hours__c),lstSRT[i].OverrideReason__c,lstSRT[i].Id,lstSRT[i].Override__c,lstSRT[i].Override_Reason__c,adjHrsFlg,notesFlg,overrideReasonFlg,i,lstSRT[i].Overlap_SRT_Title__c,String.valueof(lstSRT[i].Overlap_Step_Id__c)));
                        //subSRTWrapperMap.put(tempAccountCode+lstSRT[i].SRT_ID__c, lstOverlapsubSRTWrapper);
                        lstOverlapSRTWrapper.add(new overLapSrtWrapper(lstSRT[i].SRT_ID__c,tempAccountCode,lstOverlapsubSRTWrapper,lstSRT[i].SRT_Title__c,String.valueof(lstSRT[i].Step_Id__c)));
                        accountCodeWithOverlapMap.put(tempAccountCode,lstOverlapSRTWrapper);
                        system.debug('ELSE accountCodeWithOverlapMap-->'+accountCodeWithOverlapMap);
                        system.debug('accountCodeWithOverlapMap-->'+lstOverlapSRTWrapper);
                    }
                }

                //createOverlapMap();
                totalOverlapHours();
            }
            system.debug('accountCodeWithOverlapMap-->'+accountCodeWithOverlapMap);

        }catch(Exception ex){
            System.debug('in catch of loadOverlapSRTs of CSS_OverlapSRT>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
   
    public void createOverlapMap(){
        for(overLapSrtWrapper wrap: lstOverlapSRTWrapper){
            if(!accountCodeWithOverlapMap.containsKey(wrap.accountCode)){
                accountCodeWithOverlapMap.put(wrap.accountCode,new List<overLapSrtWrapper>{wrap});
            }else{
                accountCodeWithOverlapMap.get(wrap.accountCode).add(wrap);    
            }
        }
    }

    public void enableHrsReason(){
        system.debug('selectedSRT-->'+selectedSRT);
        system.debug('overrideCheck>>:'+isOverride);
        system.debug('selectedAcCode>>:'+selectedAcCode);
        system.debug('accountCodeWithOverlapMap'+accountCodeWithOverlapMap);
        if(selectedAcCode !=null && accountCodeWithOverlapMap !=null && accountCodeWithOverlapMap.containsKey(selectedAcCode)){
            for(overLapSrtWrapper parentWrapper : accountCodeWithOverlapMap.get(selectedAcCode)){
                for(overLapSrtSubWrapper childWrapper : parentWrapper.subSRTWrapper){
                    if(parentWrapper.SRT_Code == selectedSRT){
                        if(isOverride == true){
                            childWrapper.enableHrsReason = true;
                            childWrapper.overide = true;
                            if(childWrapper.SRT_OverlapHrs != 0){
                                childWrapper.SRT_AdjOverlapHrs = String.valueof(childWrapper.SRT_OverlapHrs);
                            }
                            else{
                                //childWrapper.SRT_AdjOverlapHrs = 0.0;
                            }
                        }
                        else{
                            childWrapper.enableHrsReason = false;
                            childWrapper.overide = false;
                            //childWrapper.SRT_AdjOverlapHrs = 0.0; //blank out
                            childWrapper.SRT_AdjOverlapHrs =null; //blank out
                            childWrapper.SRT_OverrideReason = '';
                            childWrapper.overrideReason = 'Select One';
                        }
                    }
                }
            }
        }
        system.debug('lstOverlapSRTWrapper after override--'+lstOverlapSRTWrapper);
    }

    
    //function to save the override SRTS
    public PageReference savOverlapSRT(){
        system.debug('inside saveoverlapfunction');
        errorMsgFlag = false;
        try{
            CSS_SRT__c srtObj;
            List<CSS_SRT__c> overlapSRTUpsertList = new List<CSS_SRT__c>();
            if(accountCodeWithOverlapMap.size()>0){
                //loop through all the Overlap SRTs
                for(String accCode : accountCodeWithOverlapMap.keySet()){
                    for(OverLapSrtWrapper wrap : accountCodeWithOverlapMap.get(accCode)){
                        if(wrap.subSRTWrapper.size()>0){
                            system.debug('inside of wrap.subSRTWrapper' + wrap.subSRTWrapper);
                            for(OverLapSrtSubWrapper subWrap: wrap.subSRTWrapper){
                                //if SRT is overriden then save the adjusted overlap hours and Reason
                                if(subwrap.enableHrsReason == true){
                                    system.debug('inside if of saveoverlapfunction' + subWrap);
                                    srtObj = new CSS_SRT__c();
                                    srtObj.Override__c= true;
                                    if(subwrap.SRT_AdjOverlapHrs !=null && subwrap.SRT_AdjOverlapHrs.trim() !=''){
                                        try{
                                    		srtObj.Adjusted_Overlap_Hours__c= Decimal.valueof(subwrap.SRT_AdjOverlapHrs);
                                    		subwrap.adjHrsFlag = false;
                                        }catch(Exception ex){
                                            subwrap.adjHrsFlag = true;
                                            errorMsgFlag = true;
                                            System.debug('in catch of Decimal convertion>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());    
                                        }
                                    }else{
                                        srtObj.Adjusted_Overlap_Hours__c = null;
                                        subwrap.adjHrsFlag = true;
                                    }
                                    if(subwrap.SRT_OverrideReason != null && subwrap.SRT_OverrideReason.trim() != ''){
                                        subwrap.SRT_OverrideReason = (subwrap.SRT_OverrideReason).replace('\r\n', '');
                                        subwrap.SRT_OverrideReason = (subwrap.SRT_OverrideReason).replace('\n', '');
                                        subwrap.SRT_OverrideReason = (subwrap.SRT_OverrideReason).replace('\r', '');
                                        srtObj.OverrideReason__c= subwrap.SRT_OverrideReason;
                                        subwrap.notesFlag = false;
                                    }else{
                                        srtObj.OverrideReason__c= subwrap.SRT_OverrideReason;
                                        subwrap.notesFlag = true;
                                	}
                                    srtObj.Override_Reason__c= subwrap.overrideReason;
                                    if(subwrap.overrideReason == null || subwrap.overrideReason.trim() == '' || subwrap.overrideReason =='Select One')
                                        subwrap.overrideReasonFlag = true;
                                    else
                                        subwrap.overrideReasonFlag = false;
                                    //Mandatory fields logic
                                    if(subwrap.adjHrsFlag || subwrap.notesFlag || subwrap.overrideReasonFlag)
                                        errorMsgFlag = true;
                                    srtObj.Job_Order__c = pgId;
                                    srtObj.Id = subwrap.Id;
                                    overlapSRTUpsertList.add(srtObj);
                                
                                }//else then set the adjusted overlap hours and reason to null
                                else{
                                    srtObj = new CSS_SRT__c();
                                    srtObj.Override__c= false;
                                    srtObj.OverrideReason__c= '';
                                    srtObj.Override_Reason__c= 'Select One';
                                    srtObj.Adjusted_Overlap_Hours__c= null;
                                    srtObj.Job_Order__c = pgId;
                                    srtObj.Id = subwrap.Id;
                                    overlapSRTUpsertList.add(srtObj);

                                }

                            }
                        }

                    }
                }
                //update the overlap SRTs
                if(overlapSRTUpsertList.size()>0){
                    update overlapSRTUpsertList;
                    
                    //Updating Override_Reason/Notes error message
                    //CSS_Job_Order__c jobObj = [Select Id, SRT_Olap_Reason_Msg__c from CSS_Job_Order__c where Id=:pgId];//Commented by Anirudh as the queried values where not being used anywhere
                    CSS_Job_Order__c jobObj = new CSS_Job_Order__c();
                    jobObj.Id = pgId;
                    if(errorMsgFlag)
                        jobObj.SRT_Olap_Reason_Msg__c = Label.CG_Override_Reason_Notes_value_is_required_Please_enter_value; //'Override Reason / Notes value is required. Please enter value.';
                    else
                        jobObj.SRT_Olap_Reason_Msg__c = '';
                    update jobObj;
                }
                system.debug('inside saveoverlapfunction overlapSRTUpsertList' + overlapSRTUpsertList);

            }
            //loadOverlapSRTs();
            //String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            //pageRef = new PageReference(sDestURL+'id='+JobID);
        }
        catch(Exception ex){
            errorMsgFlag = true;
            System.debug('in catch of saveOverlapSRTs>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());    
        }
        if(!errorMsgFlag){
            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            PageReference pageRef = new PageReference(sDestURL+'id='+pgId);
            pageRef.setRedirect(true);
            return pageRef;
        } else 
            return null;
    }

    public void totalOverlapHours(){
        totalHrs = 0.0;
        for(CSS_SRT__c srtHrs : lstSRT){
            if(srtHrs.Override__c == true && srtHrs.Adjusted_Overlap_Hours__c != null){
                totalHrs = totalHrs + srtHrs.Adjusted_Overlap_Hours__c;
            }
            else if(srtHrs.Override__c == false && srtHrs.Overlap_Hours__c != null){
                totalHrs = totalHrs + srtHrs.Overlap_Hours__c;
            }
        }
    }

    public List<SelectOption> getOverrideReasonList(){
        List<SelectOption> options = new List<SelectOption>();
        try{
            Schema.DescribeFieldResult fieldResult =  CSS_SRT__c.Override_Reason__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }       
        }catch(Exception ex){
            System.debug('in catch of getOverrideReasonList of CSS_OverlapSRT>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }
    
    //GSSC-289 begin     
    public String lineItemStepIdClaimsOlap {get;set;} 
    public String StepDescriptionOlap {get; set;}

    public void callJobsAccessStepDetailsOlap(){
        try{
            System.debug('in callJobsAccessStepDetailsOlap Method');
            system.debug('lineItemStepIdClaimsOlap ' + lineItemStepIdClaimsOlap);
            system.debug('EquipId ' + EquipId);
            
            StepDescriptionOlap ='';
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipId,lineItemStepIdClaimsOlap);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        StepDescriptionOlap = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                StepDescriptionOlap ='';
            
            StepDescriptionOlap = StepDescriptionOlap.replaceAll('\\n','<br/>');
            StepDescriptionOlap = StepDescriptionOlap.replaceAll('\n','<br/>');

            system.debug('StepDescriptionOlap ' + StepDescriptionOlap);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void ClaimsOlapNotesPopupOk(){
        StepDescriptionOlap='';
        system.debug('Ok button>> StepDescriptionOlap ' + StepDescriptionOlap);
    }

    //GSSC-289 End

    //Wrapper class to maintain the data related to overlapSRt s-109748
    public class overLapSrtWrapper{

        public string SRT_Code{get;set;}
        public string accountCode{get;set;}
        //GSSC-289-start
        public string srtDescription{get;set;}
        public string stepID{get;set;}
        //GSSC-289-end
        public List<overLapSrtSubWrapper> subSRTWrapper{get;set;}

        public overLapSrtWrapper(string SRT_Code,string accCode,List<overLapSrtSubWrapper> subSRTWrapper,string srtDescription,string stepID){
            this.SRT_Code = SRT_Code;
            this.accountCode = accCode;
            this.subSRTWrapper = subSRTWrapper;
            this.srtDescription = srtDescription;
            this.stepID = stepID;
        }
    }

    public class overLapSrtSubWrapper{

        public string overlapWithSRT{get;set;}
        public Decimal SRT_OverlapHrs{get;set;}
        public boolean overide{get;set;}
        public String SRT_AdjOverlapHrs{get;set;}
        public string SRT_OverrideReason{get;set;}
        public String overrideReason{get;set;}
        public Id Id{get;set;}
        public Boolean enableHrsReason{get;set;}
        public Boolean adjHrsFlag{get;set;}
        public Boolean notesFlag{get;set;}
        public Boolean overrideReasonFlag{get;set;}
        public Integer counting{get;set;}
        //GSSC-289-start
        public string OverlapsrtDescription{get;set;}
        public string OverlapstepID{get;set;}
        //GSSC-289-end

        public overLapSrtSubWrapper(string overlapWithSRT,Decimal SRT_OverlapHrs,boolean overide,String SRT_AdjOverlapHrs,string SRT_OverrideReason,Id Id,Boolean enableHrsReason,String overrideReason,Boolean adjHrsFlag,Boolean notesFlag,Boolean overrideReasonFlag,Integer counting,string OverlapsrtDescription,string OverlapstepID){
            this.overlapWithSRT = overlapWithSRT;

            this.SRT_OverlapHrs = SRT_OverlapHrs==null?0:SRT_OverlapHrs;
            this.overide = overide;
            this.SRT_AdjOverlapHrs = SRT_AdjOverlapHrs; //this.SRT_AdjOverlapHrs = SRT_AdjOverlapHrs==null?0.0:SRT_AdjOverlapHrs;
            this.SRT_OverrideReason = SRT_OverrideReason;
            this.overrideReason = overrideReason;
            this.Id = Id;
            this.enableHrsReason = enableHrsReason;
            this.adjHrsFlag = adjHrsFlag;
            this.notesFlag = notesFlag;
            this.overrideReasonFlag = overrideReasonFlag;
            this.counting = counting;
            this.OverlapsrtDescription = OverlapsrtDescription;
            this.OverlapstepID = OverlapstepID;
        }
    }
    

    public pagereference overlapsrtinvoke(){

        //loadRequestData();
        try{
            //system.debug('***overlapSRTREq--->'+overlapSRTREq);
            //if(!servicejob.CSS_SRTS__r.isEmpty()){
            /*CSS_OverlapSRTResponse overlapresponse = CSS_WS_SRT.getOverlapSRTRecords(overlapSRTREq);
system.debug('overlapresponse-->'+overlapresponse);
if(overlapresponse.DataArea!=null){
serviceJob.overlap_time__c =  overlapresponse.DataArea.TotalOverlapHours;
timemin = integer.valueof(overlapresponse.DataArea.TotalOverlapHours * 60);
TotalOverlapHours = overlapresponse.DataArea.TotalOverlapHours;
serviceJob.adjusted_time__c = overlapresponse.DataArea.TotalAdjustedHours;
timeminov = integer.valueof(overlapresponse.DataArea.TotalAdjustedHours * 60);
TotalAdjustedHours = overlapresponse.DataArea.TotalAdjustedHours;
update serviceJob;
createOverLapSrtList(overlapresponse);
}else{
overlapErrorMsg = overlapresponse.Header.Message;
}*/
            //}
        }catch (exception e){}
        return null;
    }

}