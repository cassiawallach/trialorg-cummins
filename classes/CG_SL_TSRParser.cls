public class CG_SL_TSRParser {
    
    public static CG_TSRReqJSONParser prepareReqWrapper(User currentuser,CSS_Job_Order__c ServiceJob,List<CSS_Fault_Code__c> faultCodes,List<CSS_SymptomQA__c> SymptomSrch,String TechId,String CustomerSupportLevel,String ComplaintCode,String EscalationGroup){
        try{ 
		CG_TSRReqJSONParser reqJSON = new CG_TSRReqJSONParser();        
        
        CG_TSRReqJSONParser.Header headerDetail = new CG_TSRReqJSONParser.Header();
        
        CG_TSRReqJSONParser.Sender senderDetail = new CG_TSRReqJSONParser.Sender();
        
        senderDetail.ServiceName = 'UpsertTSR';
        senderDetail.SenderID ='GUIDANZ';
        
        headerDetail.Sender = senderDetail;
        
        CG_TSRReqJSONParser.Target targetDetail = new CG_TSRReqJSONParser.Target();
        
        targetDetail.TargetID = 'TSR';
        
		headerDetail.Target = targetDetail;
        
        reqJSON.Header = headerDetail;

		CG_TSRReqJSONParser.DataArea DataAreaDetails = new CG_TSRReqJSONParser.DataArea(); 
        
        DataAreaDetails.SRNumber = '';//Will always be blank now, Later in phase 2 this functionality will come up
        
        //customer Care Support Level
        if(CustomerSupportLevel != null && CustomerSupportLevel != '')
        DataAreaDetails.SupportLevel = CustomerSupportLevel;
        else
            return null;
        
        //Service Job Details
        if(ServiceJob.ESN__c != null && ServiceJob.ESN__c != '')
            DataAreaDetails.PSN = ServiceJob.ESN__c; 
        else
            return null;
        
        DataAreaDetails.GeneralSymptoms = (ServiceJob.General_Symptoms__c != null && ServiceJob.General_Symptoms__c != '' ? ServiceJob.General_Symptoms__c : '');
        
        //SP Code - Last 5 digits of location
        String [] spCode;
        if(ServiceJob.CSS_Job_Location_Code__c != null && ServiceJob.CSS_Job_Location_Code__c != '')
        spCode = ServiceJob.CSS_Job_Location_Code__c.split('-');
        
        DataAreaDetails.SPCode = (spCode != null && spCode.size()>0 ? spCode[1] : ''); //'21945';
        
        //CustomerName
        DataAreaDetails.CustomerName = (ServiceJob.Customer_Name__c != null && ServiceJob.Customer_Name__c != '' ? ServiceJob.Customer_Name__c : '');
        
        DataAreaDetails.CSSJobID = ServiceJob.Name;
        
        DataAreaDetails.ShopWO = (ServiceJob.Shop_Work_Order__c != null && ServiceJob.Shop_Work_Order__c != '' ? ServiceJob.Shop_Work_Order__c : '');
        
        if(ServiceJob.Repeat_Visit__c == false)
            DataAreaDetails.RepeatVisit = 'N';
        else 
            DataAreaDetails.RepeatVisit = 'Y';   
        
        Date FailDateYear = Date.valueOf(ServiceJob.Failure_Date__c);
        
        String FailDate = String.valueOf(FailDateYear.day());
        String FailMonth = String.valueOf(FailDateYear.Month());
        String FailYear = String.valueOf(FailDateYear.Year());
        
        String concatenatedFailDate = FailMonth + '/' + FailDate + '/' + FailYear;
        
        DataAreaDetails.FailureDate = concatenatedFailDate;
        
        DataAreaDetails.MileageValue = (ServiceJob.Mileage__c != null && ServiceJob.Mileage__c != 0  ? String.valueOf(ServiceJob.Mileage__c) : (ServiceJob.CSS_Hours__c != null && ServiceJob.CSS_Hours__c != 0 ? String.Valueof(ServiceJob.CSS_Hours__c) : ''));
         
            if(ServiceJob.Mileage__c != null && ServiceJob.Mileage__c != 0){ 
                if(ServiceJob.Mileage_Measure__c != null && ServiceJob.Mileage_Measure__c != ''){
                    if(ServiceJob.Mileage_Measure__c.toLowerCase().contains('kilometer'))
                        DataAreaDetails.UOM = 'km';
                        else
                        DataAreaDetails.UOM = ServiceJob.Mileage_Measure__c.toLowerCase();
                }
            }else{
                DataAreaDetails.UOM = (ServiceJob.CSS_Hours__c != null && ServiceJob.CSS_Hours__c != 0 ? 'hours' : '');
            }
        
        DataAreaDetails.Status = 'Open';
        
            if(TechId == null)
                TechId = '';
        DataAreaDetails.TechID = TechId;
        
        //User Details
        if(currentuser != null){
            if(currentuser.Email != null && currentuser.Email != '')
            	DataAreaDetails.ContactEmail = currentuser.Email;
            else
                return null;
            if(currentuser.LastName != null && currentuser.LastName != '')
                DataAreaDetails.ContactLastName = currentuser.LastName;
            else
                return null;
            if(currentuser.FirstName != null && currentuser.FirstName != '')
                DataAreaDetails.ContactFirstName = currentuser.FirstName;
            else
                return null;
            DataAreaDetails.ContactPhoneNumber = (currentuser.Phone != null && currentuser.Phone != '' ? currentuser.Phone : '');
        }else{
            return null;
        }
        
        //Complaint Code
        if(ComplaintCode != null && ComplaintCode != ''){
        	DataAreaDetails.ComplaintCode = ComplaintCode;
        }else{
            return null;
        }
        
        DataAreaDetails.AttachmentURL = '';//Will always be blank now, Later in phase 2 this functionality will come up
        
        DataAreaDetails.EscalationText = '';//Will always be blank now, Later in phase 2 this functionality will come up
        
        DataAreaDetails.EscalationGroup = EscalationGroup;
        
            
        List<string> faultCodelst;
        List<string> faultStatuslst;
        	String symptom;
            system.debug('faultCodes>>>>>>>'+faultCodes);
            if(faultCodes.size()>0){
         faultCodelst = prepareFaultCodeList(faultCodes);
         faultStatuslst = prepareFaultCodeStatusList(faultCodes);
            }
            system.debug('SymptomSrch'+SymptomSrch);
        if(SymptomSrch.size()>0)    
        symptom = prepareSymptomList(SymptomSrch);
        system.debug('symptom'+symptom);
        DataAreaDetails.FaultCode = faultCodelst;
        DataAreaDetails.FaultCodeStatus = faultStatuslst;
            if(symptom == null)
                	symptom = '';
        DataAreaDetails.Symptom = symptom;
        
        reqJSON.DataArea = DataAreaDetails;
        
        
        return reqJSON;
        }catch(exception e){
            system.debug('Entered into catch block of prepareReqWrapper Method in CG_SL_TSRParser class>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
            return null;
        }
    }
    
    public static List<string> prepareFaultCodeList(List<CSS_Fault_Code__c> faultCodes){
        List<string> faultCodelst = new List<string>();
        for(CSS_Fault_Code__c fclst : faultCodes){
            if(fclst.FaultCode__c != null)
            faultCodelst.add(fclst.FaultCode__c);
            if(faultCodelst.size() == 5)
                break;
        }  
        return faultCodelst;
    }
    
    public static List<string> prepareFaultCodeStatusList(List<CSS_Fault_Code__c> faultCodes){
        List<string> faultStatuslst = new List<string>();
        for(CSS_Fault_Code__c fclst : faultCodes){
            if(fclst.Status__c == 'A')
                	fclst.Status__c = 'Active';
            if(fclst.Status__c == 'I')
                	fclst.Status__c = 'Inactive';
            faultStatuslst.add(fclst.Status__c);
            if(faultStatuslst.size() == 5)
                break;
        } 
        return faultStatuslst;
    }
    
    public static string prepareSymptomList(List<CSS_SymptomQA__c> SymptomSrch){
        String symptom;
        integer i = 0;
        for(CSS_SymptomQA__c symlst : SymptomSrch){
            if(i == 0)
               symptom = symlst.Name; 
            if(i > 0)
            symptom = symptom + ',' + symlst.Name;
            i = i + 1;
            if(i == 5)
                break;
        } 
        return symptom;
    }
}