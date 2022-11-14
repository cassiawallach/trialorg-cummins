public class CG_BL_TSR {
    
    public static void performTSRBusinessLogic(){
        try{
            //Query User Details
            Id UserId = userinfo.getuserId();
            User currentuser = new User();
            currentuser=[Select Id,FirstName,LastName,Email,Phone from User where Id=:UserId];
            
            //QueryServiceJob
            
            Id Wid = ApexPages.CurrentPage().getParameters().get('id');
            system.debug('Wid>>>>>>>>>>>>>>>>>>>>>'+Wid);
            CSS_Job_Order__c ServiceJob = new CSS_Job_Order__c();
            ServiceJob = [Select Id,Name,ESN__c,General_Symptoms__c,CSS_Hours__c,CSS_Job_Location_Code__c,Customer_Name__c,Shop_Work_Order__c,Repeat_Visit__c,Failure_Date__c,Mileage_Measure__c,Mileage__c,Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,Service_Model__c from CSS_Job_Order__c where id =: Wid ];
            
            //Query Fault Code Object
            List<CSS_Fault_Code__c> faultCodes = new List<CSS_Fault_Code__c>();
            faultCodes=[Select id,FaultCode__c,Job_Order__c,Mod__c,Status__c,
                        (Select id,name,Diagnostic_Response__c from CSS_Solutions__r) from CSS_Fault_Code__c where Job_Order__c =: Wid];
            
            //Query Symptom Object
            List<CSS_SymptomQA__c> SymptomSrch = new List<CSS_SymptomQA__c>();
            SymptomSrch = [Select id,Name,SearchString__c,Job_Order__c,Type__c,User_Name__c,
                           (Select id,name,Diagnostic_Response__c from CSS_Solutions__r) from CSS_SymptomQA__c where Job_Order__c =: Wid and Type__c = 'SearchString'];
            
            //Query Accred User Object
            List<CSS_AccredUser__c> accredUser= new List<CSS_AccredUser__c>();
            accredUser = [select Id,Promotion_Id__c,Location__c,Service_Model_Name__c,User__c from CSS_AccredUser__c where Service_Model_Name__c =: ServiceJob.Service_Model__c and Location__c =: ServiceJob.CSS_Job_Location_Code__c and User__c =: UserId];
            
            //User's Tech Id
            String TechId;
            if(accredUser.size()>0)
                TechId = (accredUser[0].Promotion_Id__c != null && accredUser[0].Promotion_Id__c != '' ? accredUser[0].Promotion_Id__c : '');
            
            //Derive Customer Support Level 
            String CustomerSupportLevel = deriveCustomerSupportLevel(ServiceJob.Repeat_Visit__c,faultCodes,SymptomSrch);
            
            //Derive Complaint Code
            String ComplaintCode = deriveComplaintCode(ServiceJob);
            
            //Call Method to check if ESN is HHP or HMLD
            String EscalationGroup = deriveEscalationGroup(ServiceJob.Service_Model__c);
            
            //Call service Layer to make Webservice Call
            CG_OP_OAGWrapper TSRCallout;
            TSRCallout = CG_SL_TSR.TSRWebservice(currentuser,ServiceJob,faultCodes,SymptomSrch,TechId,CustomerSupportLevel,ComplaintCode,EscalationGroup);
            system.debug('TSRCallout**'+TSRCallout);
            //To Store TSR Response Data
            saveTSRResponse(TSRCallout,Wid,ServiceJob.Name);
            
            
        }catch(exception e){
            system.debug('Entered into catch block of performTSRBusinessLogic in CG_BL_TSR class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    
    
    
    public static void saveTSRResponse(CG_OP_OAGWrapper TSRCallout,Id Wid,String JobId){
        
        CSS_JobForms__c jobForm = new CSS_JobForms__c();
        CSS_Job_Order__c servJob = new CSS_Job_Order__c();
        try{
            system.debug('Anirudh>>>>>>>>>>>>Callout Details'+TSRCallout);
            String TSRRequest = TSRCallout.request.getBody();
            String strTSRResponse = TSRCallout.response.getBody();
            
            CG_TSRREsJSONParser TSRResponse; 
            TSRResponse = (CG_TSRREsJSONParser)JSON.deserialize(TSRCallout.response.getBody(),CG_TSRREsJSONParser.class);
             system.debug('Anirudh>>>>>>>>>>>>TSRResponse'+TSRResponse);   
            if(TSRCallout.exceptionFlag != true){   
                
                
                Id recTypeIdTSR = css_utility.getRecordTypeId(CSS_JobForms__c.sObjectType, 'TSREscalation');
                
                if(TSRResponse.DataArea != null && TSRResponse.DataArea.TSRNumber != null && TSRResponse.DataArea.TSRNumber != ''){
                    jobForm.TSR_SRNumber__c = TSRResponse.DataArea.TSRNumber;
                    jobForm.RecordTypeId = recTypeIdTSR; 
                    jobForm.Service_Job__c = Wid;
                    
                    insert jobForm;
                    
                    CSS_JobForm_Detail__c TSRdetails = new CSS_JobForm_Detail__c();
                    TSRdetails.CSS_JobForms__c=jobForm.Id;
                    TSRdetails.TSR_ActivityDescription__c = TSRResponse.DataArea.ActivityDescription;
                    TSRdetails.TSR_ActivityID__c = TSRResponse.DataArea.ActivityID;
                    TSRdetails.TSR_ActivityOwner__c = TSRResponse.DataArea.ActivityOwner;
                    TSRdetails.TSR_ActivitySubject__c = TSRResponse.DataArea.ActivitySubject;
                    TSRdetails.TSR_ActivityType__c = TSRResponse.DataArea.ActivityType;
                    TSRdetails.TSR_Response__c = strTSRResponse;
                    TSRdetails.TSR_Request__c = TSRRequest;
                    insert TSRdetails; 
                }
                if(TSRResponse.DataArea != null){
                servJob.TSR_EscalateNumber__c = (TSRResponse.DataArea.TSRNumber != null && TSRResponse.DataArea.TSRNumber != '' ? TSRResponse.DataArea.TSRNumber : 'Error'); 
                servJob.Id = Wid;
                update servJob;
                }
            }else{
                servJob.TSR_EscalateNumber__c = 'Error';
                servJob.Id = Wid;
                update servJob;   
            }
            try{
                CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
                
                intDetails.Auth_Call_Time__c = (TSRCallout.totalAuthCallTime != null ? TSRCallout.totalAuthCallTime : 0);
                intDetails.Error_Description__c = (TSRResponse.DataArea != null && TSRResponse.DataArea.ErrorMessage != null && TSRResponse.DataArea.ErrorMessage != '' ? TSRResponse.DataArea.ErrorMessage : 'Failure');
                //Request Body
                intDetails.Processed_Data__c =  TSRCallout.request.getBody();
                intDetails.Response_Body__c = TSRCallout.response.getBody();
                intDetails.Service_Call_Time__c = (TSRCallout.totalServiceCallTime != null ? TSRCallout.totalServiceCallTime : 0);
                intDetails.Service_Job_Number__c = JobId;
                intDetails.Service_Name__c = 'TSREscalation';
                intDetails.Source__c = 'TSR';
                insert intDetails;
            }catch(exception e){
                system.debug('Entered into Insert Integration Error Log Method in cg_bl_tsr'+e.getMessage() + ' ' + e.getLineNumber());
            }
        }catch(exception e){
            system.debug('Entered into catch block of saveTSRResponse Method in CG_BL_TSR Class>>>>>>>>>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
            servJob.TSR_EscalateNumber__c = 'Error';
            servJob.Id = Wid;
            update servJob; 
        } 
    }
    
    
    public static string deriveCustomerSupportLevel(Boolean RptVstFlag,List<CSS_Fault_Code__c> faultCodes,List<CSS_SymptomQA__c> SymptomSrch){
        try{
            String CustomerSupportLevel;
            if(RptVstFlag == true){
                CustomerSupportLevel = 'Cummins CARE Level 2';
            }else{
                boolean responseisNull;
                
                //Check if for any fault code all the solutions are performed
                for(CSS_Fault_Code__c fc : faultCodes){
                    responseisNull = false;
                    for(CSS_Solutions__c sol : fc.CSS_Solutions__r){
                        if(sol.Diagnostic_Response__c == null || sol.Diagnostic_Response__c == ''){
                            responseisNull = true;
                            break;
                        }
                    }
                    if(fc.CSS_Solutions__r.size()>0)
                        if(responseisNull == false){ 
                            CustomerSupportLevel = 'Cummins CARE Level 2';
                            break;
                        }
                }
                
                //Check if for any symptom all the solutions are performed
                for(CSS_SymptomQA__c sym : SymptomSrch){
                    responseisNull = false;
                    for(CSS_Solutions__c sol : sym.CSS_Solutions__r){
                        if(sol.Diagnostic_Response__c == null || sol.Diagnostic_Response__c == ''){
                            responseisNull = true;
                            break;
                        }
                    }
                    if(sym.CSS_Solutions__r.size()>0)
                        if(responseisNull == false){ 
                            CustomerSupportLevel = 'Cummins CARE Level 2';
                            break;
                        }
                }
                if(CustomerSupportLevel != 'Cummins CARE Level 2')
                    CustomerSupportLevel = 'Cummins CARE Level 1';
            }
            return CustomerSupportLevel;
        }catch(exception e){
            system.debug('Entered into catch block of deriveCustomerSupportLevel in CG_BL_TSR class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
        return null;
    }
    
    public static string deriveComplaintCode(CSS_Job_Order__c workJob){
        try{
            String complaintType;        
            complaintType = (workJob.Complaint_Type_Desc__c != null && workJob.Complaint_Type_Desc__c != '' ? workJob.Complaint_Type_Desc__c :(workJob.Complaint_Type2_Desc__c != null && workJob.Complaint_Type2_Desc__c != '' ? workJob.Complaint_Type2_Desc__c : (workJob.Complaint_Type3_Desc__c != null && workJob.Complaint_Type3_Desc__c != '' ? workJob.Complaint_Type3_Desc__c : (workJob.Complaint_Type4_Desc__c != null && workJob.Complaint_Type4_Desc__c != '' ? workJob.Complaint_Type4_Desc__c : (workJob.Complaint_Type5_Desc__c != null && workJob.Complaint_Type5_Desc__c != '' ? workJob.Complaint_Type5_Desc__c : '')))));
            String ComplaintCode='';
            
            CSS_JobEventTemporary__c[] Categories;
            CSS_WPR_SBL_CatComplaintsListResJSON  resCatCompJSON;
            
            Categories = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'CategoryComplaintCodes'];
            system.debug('Categories>>>'+Categories);
            string jsonResponse = Categories[0].Reason__c;
            
            //jsonResponse='{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resCatCompJSON = (CSS_WPR_SBL_CatComplaintsListResJSON )JSON.deserialize(jsonResponse ,CSS_WPR_SBL_CatComplaintsListResJSON .class);
            
            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Description == complaintType){
                        ComplaintCode = det.ComplaintCode;
                    }
                }
            }
            return ComplaintCode;
        }catch(exception e){
            system.debug('Entered into catch block of deriveComplaintCode in CG_BL_TSR class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
        return null;
    }
    
    public static string deriveEscalationGroup(string SMN){
        try{
            String EngineType = '';
            if(SMN != null && SMN != ''){
                Set<String> hhpSet = new Set<String>();
                for(CSS_Listof_HHP_SMNS__c hhp: CSS_Listof_HHP_SMNS__c.getAll().Values()){
                    hhpSet.add(hhp.Listof_HHP_SMN__c);
                }
                if(hhpSet.contains(SMN)){
                    EngineType = 'HHP';
                }else{
                    EngineType = 'HMLD';
                }
                hhpSet = null;
            }
            return EngineType;
        }catch(exception e){
            system.debug('Entered into catch block of deriveEscalationGroup Method of CG_BL_TSR class'+e.getLineNumber() + '  ' +e.getMessage());
            return null;
        }
    }
}