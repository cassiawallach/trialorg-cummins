public class CG_CL_ODMMessagesController 
{
    public ID JobID{get;set;}
    public string jobODMStatus{get;set;}
    public string jobODMMsg{get;set;}
    public string failureODMStatus{get;set;}
    public string failuresODMMsg{get;set;}
    public string partsODMStatus{get;set;}
    public string partsODMMsg{get;set;}
    public boolean odmstatusFlag{get;set;}
    public boolean odmstatusCodeFlag{get;set;}
    public boolean odmsrtstatusCodeFlag{get;set;}
    public boolean odmpartstatusCodeFlag{get;set;}
    public boolean odmsolcompsatusCodeFlag{get;set;}
    public boolean checktravelratedist{get;set;}
    public boolean checklaborrate{get;set;}
    public boolean checktravelratedlr{get;set;}
    public css_job_order__c ServiceJob{get;set;}
    public css_job_order__c ServiceJob1{get;set;}
    Transient public List<CSS_Solution_component__c> solcompList{get;set;}
    Transient public List<CSS_Solution_component__c> solcompListNew{get;set;}
    Transient public List<CSS_Solution_component__c> solcompListCoverage{get;set;}
    Transient public List<css_parts_options__c> partsList{get;set;}
    Transient public List<CSS_SRT__c> SRTList{get;set;}
    Transient public List<String> headerJobRecMsg{get;set;}
    Transient public List<jobSCListWrapper> wrapjobSCList{get;set;}
    Transient public List<jobPOListWrapper> wrapjobPOList{get;set;}
    Transient public List<jobPOListWrapper> wrapjobOCList{get;set;}
    Transient public List<jobPOListWrapper> wrapjobTTMLList{get;set;}
    Transient public List<jobSRTListWrapper> wrapjobSRTList{get;set;}
    public Boolean isDealer {get; set;}
    public boolean srtsODMMesasgeflag {get; set;}
    public String  srtsODMerrMesasge{get; set;}
    public Boolean srtDuplicateError{get; set;}
    public String  srtDuplicateMsg{get; set;}
    public boolean mutuallyExcSRTFlag{get;set;}
    public boolean olapReasonSRTFlag{get;set;}
    public boolean dupAccessCodePercentReqFlag{get;set;}
    public boolean olapFailureSRTFlag{get;set;}
    public boolean admin902SRTFlag{get;set;}
    public String  mutuallyExcSRTMsg{get; set;}
    public String  olapReasonSRTMsg{get; set;}
    public String  dupAccessCodePercentReqMsg{get; set;}
    public String  olapFailureSRTMsg{get; set;}
    public String  admin902SRTMsg{get; set;}
    public Boolean isDistributor{get;set;}
    public String userRole{get;set;}
    public Boolean coverageErrorFlag{get;set;}
    public boolean getSPDataWebserviceError{get;set;}
    public boolean getFieldActionError{get;set;}
    public boolean isdealerFlag { get; set; }//Task: #190903
    public boolean licensePlateErr{get;set;}
    public CG_CL_ODMMessagesController()
    {
        try{
            licensePlateErr = false;
            headerJobRecMsg = new List<String>();
            ServiceJob = new css_job_order__C();
            ServiceJob1 = new css_job_order__C();
            solcompList = new List<CSS_Solution_component__c>();
            solcompListNew = new List<CSS_Solution_component__c>();
            solcompListCoverage = new List<CSS_Solution_component__c>();
            partsList = new List<css_parts_options__c>();
            SRTList = new List<CSS_SRT__c>();
            odmstatusFlag = false;
            odmstatusCodeFlag = false;
            odmsrtstatusCodeFlag = false;
            odmsolcompsatusCodeFlag = false;
            odmpartstatusCodeFlag = false;
            mutuallyExcSRTFlag = false;
            olapReasonSRTFlag = false;
            admin902SRTFlag = false;
            dupAccessCodePercentReqFlag = false;
            olapFailureSRTFlag = false;
            checktravelratedist=false;
            checktravelratedlr=false;
            checklaborrate=false;
            srtsODMMesasgeflag=false;
            getSPDataWebserviceError=false;
            isdealerFlag = false; //Task: #190903
            JobID = ApexPages.currentPage().getParameters().get('Id');
            String orgType = css_utility.getOrgType(UserInfo.getUserId());
            system.debug('orgType-->'+orgType);
            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            userRole = usr.UserRoleName__c;
            coverageErrorFlag = false;
            if(orgType == 'DLR'){
                isDealer = true;
                isDistributor = false;
            }
            else{
                if(orgType == 'DISTR'){
                    isDistributor = true;
                }
                isDealer = false;
            }
            try{
                // ServiceJob1 = [select id,IsDealerjob__c,CSS_Travel_Rate__c,ODM_Status__c,ODM_Status_Code__c,ODM_Status_Message__c, ODM_Pre_submit_Status__c, ODM_Pre_Submit_Status_Message__c,Mutual_Exclusive_Message__c from css_job_order__c where id=:JobID ];
                //Get Service Job ODM Validation Message
                //ServiceJob = [select id,ODM_Status__c,ODM_Status_Message__c, ODM_Pre_submit_Status__c, ODM_Pre_Submit_Status_Message__c from css_job_order__c where id=:JobID and ODM_Status__c!=null and (ODM_Status__c='ERROR' OR ODM_Status__c='WARN')]; 
                //ServiceJob = [select id,IsDealerjob__c,CSS_Travel_Rate__c,ODM_Status__c,ODM_Status_Code__c,ODM_Status_Message__c, ODM_Pre_submit_Status__c, ODM_Pre_Submit_Status_Message__c,Mutual_Exclusive_Message__c from css_job_order__c where id=:JobID and  (((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!=null and (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED'))) OR (Mutual_Exclusive_Message__c != null and Mutual_Exclusive_Message__c != ''))]; 
                ServiceJob = [select id,DuplicateSRTDetails__c,CSS_Travel_Rate__c,CSS_In_Shop_Labor_Rate__c,SPDataWebserviceResult__c,FieldActionWebServiceResult__c,ODM_Status__c,ODM_Status_Code__c,
                              ODM_Status_Message__c, ODM_Pre_submit_Status__c, ODM_Pre_Submit_Status_Message__c,Mutual_Exclusive_Message__c,SRT_Olap_Reason_Msg__c,SRT_902_Error_Message__c,License_Plate__c,
                              DupAccessCodePercentReqMsg__c,Overlap_Service_Failure_Msg__c, Account__c, Account__r.Type
                              from css_job_order__c where id=:JobID ]; //Added [Account__c, Account__r.Type] for Task: #190903

                if(((ServiceJob.ODM_Status_Code__c != null && ServiceJob.ODM_Status_Code__c != '200') || (ServiceJob.ODM_Status__c!=null && (ServiceJob.ODM_Status__c!='YTBV' && ServiceJob.ODM_Status__c!='NA' && ServiceJob.ODM_Status__c!='PASSED'))))
                {
                    jobODMStatus = ServiceJob.ODM_Status__c;
                    //jobODMMsg = ServiceJob.ODM_Status_Message__c;
                }
                
                //Task: #190903 
                if(ServiceJob != null && ServiceJob.Account__c != null && ServiceJob.Account__r.Type != null && ServiceJob.Account__r.Type != '') {
                    if(ServiceJob.Account__r.Type.contains('dealer'))
                       isdealerFlag = true; 
                }
                //Task: #190903
            }
            catch(Exception e){}
            system.debug('ServiceJob**'+ServiceJob);
            system.debug('11 Mutual_Exclusive_Message__c>>>>'+ServiceJob.Mutual_Exclusive_Message__c);
            system.debug('11 SRT_Olap_Reason_Msg__c>>>>'+ServiceJob.SRT_Olap_Reason_Msg__c);
            try{
                //Get Failures ODM Validation Messages
                //solcompList = [select id,ODM_Status__c,ODM_Status_Message__c,component_id__c,FailCode_Formula__c from CSS_Solution_component__c where Service_Job__c=:JobID and ODM_Status__c!=null and (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED')]; 
                solcompListNew = [select id,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,component_id__c,FailCode_Formula__c, CoverageLimitExceedMsg_Status__c, CoverageLimitExceedMsg__c,CoverageLimitExceedMsgSRT__c, CoverageLimitExceedMsgSRT_Status__c,CSS_Account_Formula__c,Selected_Component__c  from CSS_Solution_component__c where Service_Job__c=:JobID and 	Selected_Component__c=true]; //and ((ODM_Status__c!=null and ((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED'))) or (CoverageLimitExceedMsg_Status__c != 'PASSED' and CoverageLimitExceedMsg_Status__c != '' and CoverageLimitExceedMsg_Status__c != null))
                //solcompList = [select id,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,component_id__c,FailCode_Formula__c, CoverageLimitExceedMsg_Status__c, CoverageLimitExceedMsg__c from CSS_Solution_component__c where Service_Job__c=:JobID and ((ODM_Status__c!=null and ((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED'))) or (CoverageLimitExceedMsg_Status__c != 'PASSED' and CoverageLimitExceedMsg_Status__c != '' and CoverageLimitExceedMsg_Status__c != null))]; 
                system.debug('solcompListNew-->'+solcompListNew);
                 
                for(CSS_Solution_component__c solcomp:solcompListNew){
                    
                    if(solcomp.CSS_Account_Formula__c!=null && solcomp.CSS_Account_Formula__c=='Emission Warranty 70'  && (ServiceJob.License_Plate__c==null || ServiceJob.License_Plate__c=='' || ServiceJob.License_Plate__c=='Select One' )){
                        system.debug('ServiceJob value'+ServiceJob.License_Plate__c);
                        licensePlateErr=true;
                    }
                    
                }
                for(CSS_Solution_component__c sc : solcompListNew){
                    if(sc.ODM_Status__c!=null && ((sc.ODM_Status_Code__c != null && sc.ODM_Status_Code__c != '200') || (sc.ODM_Status__c!='YTBV' && sc.ODM_Status__c!='NA' && sc.ODM_Status__c!='PASSED'))){
                        solcompList.add(sc);
                    }
                    if(sc.CoverageLimitExceedMsg_Status__c == 'ERROR' || sc.CoverageLimitExceedMsgSRT_Status__c == 'ERROR'){
                        coverageErrorFlag = true;
                        solcompListCoverage.add(sc);
                    }

                }
                system.debug('solcompListCoverage-->'+solcompListCoverage);
            }catch(Exception ex){
                System.debug('in catch of constructor of CG_CL_ODMMessagesController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            }

            try{//Get Parts ODM Validation Messages
                //partsList = [select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,type__c,Item__c,RecordType.Name from CSS_Parts_Options__c where Service_Job__c=:JobID and ODM_Status__c!=null and (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED')]; 
                partsList = [select id,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,Service_partnumber__c,type__c,Item__c,RecordType.Name from CSS_Parts_Options__c where Service_Job__c=:JobID and ODM_Status__c!=null and ((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED'))]; 
            }catch(Exception e){}
            try{//Get SRT ODM Validation Messages
                //SRTList = [select id,ODM_Status__c,ODM_Status_Message__c,SRT_ID__c,FailCode__c  from CSS_SRT__c where Job_Order__c=:JobID and ODM_Status__c!=null and (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED')]; 
                SRTList = [select id,ODM_Status__c,ODM_Status_Message__c,SRT_ID__c,FailCode__c,ODM_Status_Code__c  from CSS_SRT__c where Job_Order__c=:JobID and ODM_Status__c!=null and ((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED'))]; 
            }catch(Exception e){}
            system.debug('solcompList**'+solcompList);
            system.debug('partsList**'+partsList);
            system.debug('SRTList**'+SRTList);
            /*if((ServiceJob.ODM_Status__c==null || (ServiceJob.ODM_Status__c!=null && (ServiceJob.ODM_Status__c!='ERROR' || ServiceJob.ODM_Status__c!='WARN'))) && solcompList.Size()==0 && partslist.Size()==0 && SRTList.Size()==0 )
        odmstatusFlag=true;*/
            //if((ServiceJob.ODM_Status__c!=null && (ServiceJob.ODM_Status__c!='ERROR' || ServiceJob.ODM_Status__c!='WARN') && (ServiceJob.ODM_Status_Message__c != '' && ServiceJob.ODM_Status_Message__c != null)) || (solcompList.Size()>0 || partslist.Size()>0 || SRTList.Size()>0 ))
            if((ServiceJob.ODM_Status__c!=null && (ServiceJob.ODM_Status__c!='YTBV' || ServiceJob.ODM_Status__c!='NA') && (ServiceJob.ODM_Status_Message__c != '' && ServiceJob.ODM_Status_Message__c != null)) || (solcompList.Size()>0 || partslist.Size()>0 || SRTList.Size()>0 )){
                odmstatusFlag=true;
            }
            if(ServiceJob.ODM_Status_Code__c != null && ServiceJob.ODM_Status_Code__c != '200'){
                odmstatusCodeFlag=true;
            }
            for(css_Srt__C srt: SRTList){
                if(srt.ODM_Status_Code__c != null && srt.ODM_Status_Code__c != '200'){
                    odmsrtStatusCodeFlag = true;
                    break;
                }
            }
            for(Css_parts_options__c part: partsList){
                if(part.ODM_Status_Code__c != null && part.ODM_Status_Code__c != '200'){
                    odmpartstatusCodeFlag = true;
                    break;
                }
            }
            for(Css_Solution_Component__C solComp: solcompList){
                if(solComp.ODM_Status_Code__c != null && solComp.ODM_Status_Code__c != '200'){
                    odmsolcompsatusCodeFlag = true;
                    break;
                }
            }
            if(ServiceJob.Mutual_Exclusive_Message__c != '' && ServiceJob.Mutual_Exclusive_Message__c != null){
                mutuallyExcSRTFlag = true;
                mutuallyExcSRTMsg = ServiceJob.Mutual_Exclusive_Message__c;
                system.debug('22 Mutual_Exclusive_Message__c>>>>'+ServiceJob.Mutual_Exclusive_Message__c);
            }
            if(ServiceJob.SRT_Olap_Reason_Msg__c != '' && ServiceJob.SRT_Olap_Reason_Msg__c != null){
                olapReasonSRTFlag = true;
                olapReasonSRTMsg = ServiceJob.SRT_Olap_Reason_Msg__c;
                system.debug('22 SRT_Olap_Reason_Msg__c>>>>'+ServiceJob.SRT_Olap_Reason_Msg__c);
            }
            if(ServiceJob.DupAccessCodePercentReqMsg__c != '' && ServiceJob.DupAccessCodePercentReqMsg__c != null){
                dupAccessCodePercentReqFlag = true;
                dupAccessCodePercentReqMsg = ServiceJob.DupAccessCodePercentReqMsg__c;
                system.debug('22 DupAccessCodePercentReqMsg__c>>>>'+ServiceJob.DupAccessCodePercentReqMsg__c);
            }
            if(ServiceJob.Overlap_Service_Failure_Msg__c != '' && ServiceJob.Overlap_Service_Failure_Msg__c != null){
                olapFailureSRTFlag = true;
                olapFailureSRTMsg = ServiceJob.Overlap_Service_Failure_Msg__c;
                system.debug('22 Overlap_Service_Failure_Msg__c>>>>'+ServiceJob.Overlap_Service_Failure_Msg__c);
            }
            if(ServiceJob.SRT_902_Error_Message__c != '' && ServiceJob.SRT_902_Error_Message__c != null){
                admin902SRTFlag = true;
                admin902SRTMsg = ServiceJob.SRT_902_Error_Message__c;
                system.debug('22 SRT_902_Error_Message__c>>>>'+ServiceJob.SRT_902_Error_Message__c);
            }
            if(ServiceJob.DuplicateSRTDetails__c != null && ServiceJob.DuplicateSRTDetails__c != ''){
                srtDuplicateError=true;
                srtDuplicateMsg='SRTs ('+ServiceJob.DuplicateSRTDetails__c+') have already been applied. Please confirm that additional quantity is needed.';
            }

            if(string.isBlank(ServiceJob.CSS_Travel_Rate__c) || (string.isNotBlank(ServiceJob.CSS_Travel_Rate__c) && double.valueOf(ServiceJob.CSS_Travel_Rate__c)==0))
            {

                if(isDealer == true)//(ServiceJob.IsDealerjob__c)
                {
                    checktravelratedlr=true;
                    checktravelratedist=false;
                }
                else
                {
                    checktravelratedist=true;
                    checktravelratedlr=false;
                }
            }
            if(string.isBlank(ServiceJob.CSS_In_Shop_Labor_Rate__c) || (string.isNotBlank(ServiceJob.CSS_In_Shop_Labor_Rate__c) && double.valueOf(ServiceJob.CSS_In_Shop_Labor_Rate__c)==0))
            {
                checklaborrate=true;
                //getSPDataWebserviceError=true;
            }
            system.debug('***checklaborrate***'+checklaborrate+'SPDataWebserviceResult__c****'+ServiceJob.SPDataWebserviceResult__c);
            if(checklaborrate==true && ServiceJob.SPDataWebserviceResult__c.contains('Error')){
                getSPDataWebserviceError=true;
            }
            
            if(ServiceJob.FieldActionWebServiceResult__c.contains('Error')){
                getFieldActionError = true;
            }
            
            splitheaderjobRecStatusMsg();
            splitRelatedStatusMsg();
        }
        catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ODMMessagesController constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    public void splitheaderjobRecStatusMsg() {
        system.debug('InsideHeader**');
        String[] JobODMmsg;
        if(ServiceJob.ODM_Status_Message__c!=null && ServiceJob.ODM_Status_Message__c!=''){
            JobODMmsg=ServiceJob.ODM_Status_Message__c.split('\\;;')  ;
            system.debug('InsideHeader**'+JobODMmsg);
            if(JobODMmsg!=null && JobODMmsg.size()>0){
                for(string s: JobODMmsg){
                    headerJobRecMsg.add(s);
                }
            }
            else{
                headerJobRecMsg.add(ServiceJob.ODM_Status_Message__c);
            }
        }

        //Pre-Submit.
        String[] JobPSODMmsg;
        if(ServiceJob.ODM_Pre_Submit_Status_Message__c!=null && ServiceJob.ODM_Pre_Submit_Status_Message__c!=''){
            JobPSODMmsg=ServiceJob.ODM_Pre_Submit_Status_Message__c.split('\\;;')  ;
            system.debug('InsideHeader**'+JobPSODMmsg);
            if(JobPSODMmsg!=null && JobPSODMmsg.size()>0){
                for(string s: JobPSODMmsg){
                    headerJobRecMsg.add(s);
                }
            }
            else{
                headerJobRecMsg.add(ServiceJob.ODM_Pre_Submit_Status_Message__c);
            }
        }
    }

    public void splitRelatedStatusMsg() {
        wrapjobSCList = new List<jobSCListWrapper>();
        wrapjobPOList = new List<jobPOListWrapper>();
        wrapjobOCList = new List<jobPOListWrapper>();
        wrapjobTTMLList = new List<jobPOListWrapper>();
        wrapjobSRTList = new List<jobSRTListWrapper>();
        String[] jobSCODMmsg;
        String[] jobPOODMmsg;
        String[] jobSRTODMmsg;
        if(solcomplist!=null  && solcomplist.size()>0 ){
            system.debug('solcomplist**'+solcomplist);
            for(CSS_Solution_component__c sol :solcomplist){
                if(sol.ODM_Status_Message__c != null && sol.ODM_Status_Message__c != '')
                    jobSCODMmsg=sol.ODM_Status_Message__c.split('\\;;'); 
                system.debug('jobSCODMmsg**'+jobSCODMmsg);
                if(jobSCODMmsg!=null && jobSCODMmsg.size()>0){
                    for(String st:jobSCODMmsg){
                        jobSCListWrapper solWrap = new jobSCListWrapper();
                        //solWrap.failcode=sol.FailCode_Formula__c;
                        solWrap.odmStatus=sol.ODM_Status__c;
                        solWrap.odmStatusMsg=st;
                        wrapjobSCList.add(solWrap);
                    }
                }
                else{

                    jobSCListWrapper solWrap = new jobSCListWrapper();
                    // solWrap.failcode=sol.FailCode_Formula__c;
                    solWrap.odmStatus=sol.ODM_Status__c;
                    solWrap.odmStatusMsg=sol.ODM_Status_Message__c;
                    wrapjobSCList.add(solWrap);
                }
                system.debug('isDistributor-->'+isDistributor);
            }
        }
        if(solcompListCoverage != null  && solcompListCoverage.size() > 0){
            system.debug('solcompListCoverage--'+solcompListCoverage);
            for(CSS_Solution_component__c sol :solcompListCoverage){
                jobSCListWrapper solWrap = new jobSCListWrapper();
                system.debug('sol.CoverageLimitExceedMsg_Status__c-->'+sol.CoverageLimitExceedMsg__c);
                if(sol.CoverageLimitExceedMsg_Status__c == 'ERROR'){
                    if(sol.CoverageLimitExceedMsg__c.contains('Fail Code')){ //Added as part of the story GSSC-50
                        solWrap.odmStatus=sol.CoverageLimitExceedMsg_Status__c;
                        solWrap.odmStatusMsg='Error: '+sol.CoverageLimitExceedMsg__c;
                        wrapjobSCList.add(solWrap);
                    }
                    else{
                        if(isDistributor == false || (userRole!= null && userRole.contains('Factory'))){
                            solWrap.odmStatus=sol.CoverageLimitExceedMsg_Status__c;
                            solWrap.odmStatusMsg='Error: '+sol.CoverageLimitExceedMsg__c;
                            wrapjobSCList.add(solWrap);
                        }
                    }
                }
                system.debug('wrapjobSCList--'+wrapjobSCList);
            }
        }
        system.debug('wrapjobSCList'+wrapjobSCList);
        if(partsList!=null  && partsList.size()>0 ){
            system.debug('partsList**'+partsList);
            for(CSS_Parts_Options__c PO :partsList){
                if(PO.RecordType.Name == 'BMS Parts' || PO.RecordType.Name == 'Parts'){
                    if(PO.ODM_Status_Message__c != null && PO.ODM_Status_Message__c != '')
                        jobPOODMmsg=PO.ODM_Status_Message__c.split('\\;;'); 
                    // system.debug('jobPOODMmsg**'+jobPOODMmsg);
                    system.debug('PO**'+PO);
                    if(jobPOODMmsg!=null && jobPOODMmsg.size()>0){
                        for(String st:jobPOODMmsg){
                            jobPOListWrapper POWrap = new jobPOListWrapper();
                            POWrap.partnumber=PO.Service_partnumber__c;
                            POWrap.RecordType=PO.RecordType.Name;
                            POWrap.odmStatus=PO.ODM_Status__c;
                            POWrap.odmStatusMsg=st;
                            wrapjobPOList.add(POWrap);
                        }
                    }
                    else{
                        system.debug('POELSE**'+PO);
                        jobPOListWrapper POWrap = new jobPOListWrapper();
                        POWrap.partnumber=PO.Service_partnumber__c;
                        POWrap.RecordType=PO.RecordType.Name;
                        POWrap.odmStatus=PO.ODM_Status__c;
                        POWrap.odmStatusMsg=PO.ODM_Status_Message__c;
                        wrapjobPOList.add(POWrap);
                    }
                }
                if(PO.RecordType.Name == 'OtherClaimables'){
                    if(PO.ODM_Status_Message__c != null && PO.ODM_Status_Message__c != '')
                        jobPOODMmsg=PO.ODM_Status_Message__c.split('\\;;'); 
                    // system.debug('jobPOODMmsg**'+jobPOODMmsg);
                    system.debug('PO**'+PO);
                    if(jobPOODMmsg!=null && jobPOODMmsg.size()>0){
                        for(String st:jobPOODMmsg){
                            jobPOListWrapper POWrap = new jobPOListWrapper();
                            POWrap.partnumber=PO.Service_partnumber__c;
                            POWrap.RecordType=PO.RecordType.Name;
                            POWrap.odmStatus=PO.ODM_Status__c;
                            POWrap.odmStatusMsg=st;
                            wrapjobOCList.add(POWrap);
                        }
                    }
                    else{
                        system.debug('POELSE**'+PO);
                        jobPOListWrapper POWrap = new jobPOListWrapper();
                        POWrap.partnumber=PO.Service_partnumber__c;
                        POWrap.RecordType=PO.RecordType.Name;
                        POWrap.odmStatus=PO.ODM_Status__c;
                        POWrap.odmStatusMsg=PO.ODM_Status_Message__c;
                        wrapjobOCList.add(POWrap);
                    }
                }
                if(PO.RecordType.Name == 'TTML'){
                    if(PO.ODM_Status_Message__c != null && PO.ODM_Status_Message__c != '')
                        jobPOODMmsg=PO.ODM_Status_Message__c.split('\\;;'); 
                    // system.debug('jobPOODMmsg**'+jobPOODMmsg);
                    system.debug('PO**'+PO);
                    if(jobPOODMmsg!=null && jobPOODMmsg.size()>0){
                        for(String st:jobPOODMmsg){
                            jobPOListWrapper POWrap = new jobPOListWrapper();
                            POWrap.partnumber=PO.Service_partnumber__c;
                            POWrap.RecordType=PO.RecordType.Name;
                            POWrap.odmStatus=PO.ODM_Status__c;
                            POWrap.odmStatusMsg=st;
                            wrapjobTTMLList.add(POWrap);
                        }
                    }
                    else{
                        system.debug('POELSE**'+PO);
                        jobPOListWrapper POWrap = new jobPOListWrapper();
                        POWrap.partnumber=PO.Service_partnumber__c;
                        POWrap.RecordType=PO.RecordType.Name;
                        POWrap.odmStatus=PO.ODM_Status__c;
                        POWrap.odmStatusMsg=PO.ODM_Status_Message__c;
                        wrapjobTTMLList.add(POWrap);
                    }
                }
            }
        }
        if(SRTList!=null  && SRTList.size()>0 ){
            for(CSS_SRT__c srt :SRTList){
                if(srt.ODM_Status_Message__c != null && srt.ODM_Status_Message__c != '')
                    jobSRTODMmsg=srt.ODM_Status_Message__c.split('\\;;'); 
                if(jobSRTODMmsg!=null && jobSRTODMmsg.size()>0){
                    for(String st:jobSRTODMmsg){
                        jobSRTListWrapper srtWrap = new jobSRTListWrapper();
                        srtWrap.failcode=srt.FailCode__c;
                        srtWrap.odmStatus=srt.ODM_Status__c;
                        srtWrap.odmStatusMsg=st;
                        wrapjobSRTList.add(srtWrap);
                    }
                }
                else{
                    jobSRTListWrapper srtWrap = new jobSRTListWrapper();
                    srtWrap.failcode=srt.FailCode__c;
                    srtWrap.odmStatus=srt.ODM_Status__c;
                    srtWrap.odmStatusMsg=srt.ODM_Status_Message__c;
                    wrapjobSRTList.add(srtWrap);
                }
            }
        }
        if(solcompListCoverage != null  && solcompListCoverage.size() > 0){
            system.debug('solcompListCoverage--'+solcompListCoverage);
            for(CSS_Solution_component__c sol :solcompListCoverage){
           //     if(isDistributor == false || (userRole!= null && userRole.contains('Factory'))){
                    jobSRTListWrapper solWrap = new jobSRTListWrapper();
                    if(sol.CoverageLimitExceedMsgSRT_Status__c == 'ERROR'){
                        solWrap.odmStatus=sol.CoverageLimitExceedMsgSRT_Status__c;
                        solWrap.odmStatusMsg='Error: '+sol.CoverageLimitExceedMsgSRT__c;
                    }
                    wrapjobSRTList.add(solWrap);
           //     }
                system.debug('wrapjobSRTList--'+wrapjobSRTList);
            }
        }
    }
    public class jobSCListWrapper{
        public String failcode{get;set;}
        public String odmStatus{get;set;}
        public String odmStatusMsg{get;set;}
    }

    public class jobPOListWrapper{
        public String partnumber{get;set;}
        public String odmStatus{get;set;}
        public String odmStatusMsg{get;set;}
        public String RecordType{get;set;}
    }

    public class jobSRTListWrapper{
        public String failcode{get;set;}
        public String odmStatus{get;set;}
        public String odmStatusMsg{get;set;}
    }
}