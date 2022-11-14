public class CG_Escalate {
    
    public Id JobId{get;set{JobId=value;}}
    public String TSRNumber{get;set;}
    
    
    
    public CG_Escalate()
    {
        //EscalationView();
    }
    
    public String requestMessage{get;set;}
    public String responseMessage{get;set;}
    public String TSRNumbermsg{get;set;}
    public String LastModifiedDte{get;set;}
    public void EscalationView(){
        try{
            JobId = apexpages.currentPage().getParameters().get('id');
            system.debug('JobId'+JobId);
            String complaintType;
            
            List<CSS_JobForms__c> JF = new List<CSS_JobForms__c>();
            List<CSS_JobForm_Detail__c> TSRDetail = new List<CSS_JobForm_Detail__c>();
            CG_TSRReqJSONParser reqTSRJSON;
            CG_TSRResJSONParser resTSRJSON;
            Id recTypeIdEscalate = css_utility.getRecordTypeId(CSS_JobForm_Detail__c.sObjectType, 'TSREscalation');
            system.debug('recTypeIdEscalate'+recTypeIdEscalate);
            JF = [Select id, TSR_SRNumber__c  from css_jobforms__c where Service_Job__c = :JobId and RecordType.Name = 'TSREscalation'];
            system.debug('JF>>>>>>'+JF+'JObId'+JobId);
            if(JF.size()>0){
                TSRDetail = [Select Id, LastModifiedDate, TSR_Request__c,TSR_Response__c,TSR_ActivityType__c, TSR_ActivityID__c, TSR_ActivityOwner__c, TSR_ActivitySubject__c, TSR_ActivityDescription__c from CSS_JobForm_Detail__c where CSS_JobForms__c=:JF[0].id]; 
             system.debug('TSRDetail'+TSRDetail);
                if(TSRDetail.size()>0)
                    LastModifiedDte = TSRDetail[0].LastModifiedDate.format('dd MMM YYYY hh:mm a z');
                
                    
                string jsonRequest = TSRDetail[0].TSR_Request__c;
                string jsonResponse = TSRDetail[0].TSR_Response__c;
                
                //jsonResponse='{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
                if(jsonRequest != null && jsonRequest != '')
                    reqTSRJSON = (CG_TSRReqJSONParser )JSON.deserialize(jsonRequest ,CG_TSRReqJSONParser.class);
                if(jsonResponse != null && jsonResponse != '')
                    resTSRJSON = (CG_TSRResJSONParser )JSON.deserialize(jsonResponse ,CG_TSRResJSONParser.class);
                
                if(reqTSRJSON.DataArea.ComplaintCode != null && reqTSRJSON.DataArea.ComplaintCode != '')
                complaintType = deriveComplaintType(reqTSRJSON.DataArea.ComplaintCode);
            } 
            
           // List<string> fcstatus = new List<string>();
            system.debug('reqTSRJSON.DataArea.ComplaintCode'+reqTSRJSON.DataArea.ComplaintCode);
            system.debug('reqTSRJSON.DataArea.FaultCodeStatus'+reqTSRJSON.DataArea.FaultCodeStatus);
                            system.debug('reqTSRJSON.DataArea.ShopWO'+reqTSRJSON.DataArea.ShopWO);
           /* if(reqTSRJSON.DataArea.FaultCodeStatus!= null)
            for(String fcsts : reqTSRJSON.DataArea.FaultCodeStatus){
                 if(fcsts == 'A')
                     fcstatus.add('Active');
                if(fcsts == 'I')
                    fcstatus.add('INActive');
            }*/
            system.debug('requestMessage'+requestMessage);
            requestMessage = (reqTSRJSON.DataArea.ContactFirstName != null && reqTSRJSON.DataArea.ContactFirstName!= '' ? 'First Name: ' + reqTSRJSON.DataArea.ContactFirstName : '') + ' ' + (reqTSRJSON.DataArea.ContactLastName != null && reqTSRJSON.DataArea.ContactLastName!= '' ? 'Last Name: ' + reqTSRJSON.DataArea.ContactLastName : '') + ' '
                +(reqTSRJSON.DataArea.TechID != null && reqTSRJSON.DataArea.TechID!= '' ? 'Tech ID: ' + reqTSRJSON.DataArea.TechID : '') + ' ' + (reqTSRJSON.DataArea.ContactEmail != null && reqTSRJSON.DataArea.ContactEmail!= '' ? 'Email: ' + reqTSRJSON.DataArea.ContactEmail : '') + ' ' + (reqTSRJSON.DataArea.SPCode != null && reqTSRJSON.DataArea.SPCode!= '' ? 'SP Code: ' + reqTSRJSON.DataArea.SPCode : '') + ' '
                +(reqTSRJSON.DataArea.CSSJobID != null && reqTSRJSON.DataArea.CSSJobID!= '' ? 'CSS Job Number: ' + reqTSRJSON.DataArea.CSSJobID : '') + ' ' + (reqTSRJSON.DataArea.PSN != null && reqTSRJSON.DataArea.PSN!= '' ? 'PSN: ' + reqTSRJSON.DataArea.PSN : '') + ' ' + (reqTSRJSON.DataArea.EscalationGroup != null && reqTSRJSON.DataArea.EscalationGroup!= '' ? 'Engine Class: ' + reqTSRJSON.DataArea.EscalationGroup : '') + ' '
                +(reqTSRJSON.DataArea.CustomerName != null && reqTSRJSON.DataArea.CustomerName!= '' ? 'Customer Name: ' + reqTSRJSON.DataArea.CustomerName : '') + ' ' + (reqTSRJSON.DataArea.FailureDate != null && reqTSRJSON.DataArea.FailureDate!= '' ? 'Failure Date: ' + reqTSRJSON.DataArea.FailureDate : '') + ' ' + (reqTSRJSON.DataArea.MileageValue != null && reqTSRJSON.DataArea.MileageValue!= '' ? 'Product Mileage: ' + reqTSRJSON.DataArea.MileageValue : '') + ' '
                +(reqTSRJSON.DataArea.UOM != null && reqTSRJSON.DataArea.UOM!= '' ? 'UOM: ' + reqTSRJSON.DataArea.UOM : '') + ' ' + (reqTSRJSON.DataArea.GeneralSymptoms != null && reqTSRJSON.DataArea.GeneralSymptoms != '' ? 'General Symptoms: ' + reqTSRJSON.DataArea.GeneralSymptoms : '') + ' ' + (complaintType != null && complaintType != '' ? 'Complaint: ' + complaintType : '') + ' ' + (reqTSRJSON.DataArea.ShopWO != null && reqTSRJSON.DataArea.ShopWO!= '' ? 'Shops WO#: ' + reqTSRJSON.DataArea.ShopWO : '') +  ' '
                +(reqTSRJSON.DataArea.FaultCode != null && reqTSRJSON.DataArea.FaultCode.size()>0 ? 'Fault Codes: ' + reqTSRJSON.DataArea.FaultCode : '') + ' ' + (reqTSRJSON.DataArea.FaultCodeStatus != null && reqTSRJSON.DataArea.FaultCodeStatus.size()>0 ? 'Fault Code Status: ' + reqTSRJSON.DataArea.FaultCodeStatus : '') + ' ' + (reqTSRJSON.DataArea.Symptom != null && reqTSRJSON.DataArea.Symptom != '' ? 'Symptom: ' + reqTSRJSON.DataArea.Symptom : '');  
            
            system.debug('requestMessage'+requestMessage);
            
            TSRNumbermsg = (resTSRJSON.DataArea.TSRNumber != null && resTSRJSON.DataArea.TSRNumber!= '' ? 'Cummins Care Request Number: ' + resTSRJSON.DataArea.TSRNumber : '');
            responseMessage = ' ' + (resTSRJSON.DataArea.ActivityType != null && resTSRJSON.DataArea.ActivityType!= '' ? 'Activity Type: ' + resTSRJSON.DataArea.ActivityType : '') + ' ' + (resTSRJSON.DataArea.ActivityID != null && resTSRJSON.DataArea.ActivityID!= '' ? 'Activity ID: ' + resTSRJSON.DataArea.ActivityID : '') + ' ' + (resTSRJSON.DataArea.ActivityOwner != null && resTSRJSON.DataArea.ActivityOwner!= '' ? 'Activity Owner: ' + resTSRJSON.DataArea.ActivityOwner : '') + ' '
                +(resTSRJSON.DataArea.ActivitySubject != null && resTSRJSON.DataArea.ActivitySubject!= '' ? 'Activity Subject: ' + resTSRJSON.DataArea.ActivitySubject : '') + ' ' + (resTSRJSON.DataArea.ActivityDescription != null && resTSRJSON.DataArea.ActivityDescription!= '' ? 'Activity Description: ' + resTSRJSON.DataArea.ActivityDescription : '') + ' ' + (resTSRJSON.DataArea.ErrorMessage != null && resTSRJSON.DataArea.ErrorMessage!= '' && resTSRJSON.DataArea.ErrorMessage != 'Success' ? 'Error Message: ' + resTSRJSON.DataArea.ErrorMessage : '')
                + ' ' +(resTSRJSON.DataArea.ErrorCode != null && resTSRJSON.DataArea.ErrorCode!= '' ? 'Error Code: ' + resTSRJSON.DataArea.ErrorCode : '');
            
        }catch(exception e){
            system.debug('Entered into catch block of Esclation view method in CG_Escalate class>>>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
        }     
        
    }
    
     public static string deriveComplaintType(String complaintCode){
        try{
            String complaintType;
           CSS_JobEventTemporary__c[] Categories;
            CSS_WPR_SBL_CatComplaintsListResJSON  resCatCompJSON;
            
            Categories = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'CategoryComplaintCodes'];
            system.debug('Categories>>>'+Categories);
            string jsonResponse = Categories[0].Reason__c;
            
            //jsonResponse='{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resCatCompJSON = (CSS_WPR_SBL_CatComplaintsListResJSON )JSON.deserialize(jsonResponse ,CSS_WPR_SBL_CatComplaintsListResJSON .class);
            
            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ComplaintCode == complaintCode){
                        complaintType = det.Description;
                    }
                }
            }
            return complaintType;
        }catch(exception e){
            system.debug('Entered into catch block of deriveComplaintCode in CG_BL_TSR class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
        return null;
    }
    
}