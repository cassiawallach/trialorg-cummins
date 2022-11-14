/***********************************************************************************************
Name:FSL_CL_FormsController
==============================================================================================
==============================================================================================
Purpose:                            

-------  
This class is to fetch and display saved JSA forms in the forms table under forms tab.
==============================================================================================
==============================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE                                   
1.0         PiyushR                    10/21/2019                         
************************************************************************************************/ 
public class FSL_CL_FormsController {
	
    @AuraEnabled
    public static List<formWrapper> fetchFormsDetails(String workOrderId) {
        List<formWrapper> formWrapperList = new List<formWrapper>();
        System.debug(':::WorkOrder ID = '+workOrderId);
        try {
            List<CSS_JobForms__c> formsList = [SELECT Id, CreatedById, CreatedBy.Name, CreatedBy.firstname, CreatedBy.lastname, Form_Start_Time__c, Form_Initiate_Time__c,  LastModifiedDate, JSA_File_Name__c, RecordType.Name FROM CSS_JobForms__c where servicejob__c =:workOrderId  and (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name = 'InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') order by LastModifiedDate desc ];
            System.debug(':::CSS Forms List - '+formsList.size()+' * and * '+formsList);
            if(!formsList.isEmpty() && formsList.size() > 0) {
                String FormType;
                String PageName;
                for(CSS_JobForms__c form: formsList){
                    system.debug(':::CSS_JobForms '+ form);
                    
                    if(form.RecordType.Name == 'JSAForms' || form.RecordType.Name == ''){
                        FormType = 'JSA';
                        pageName = 'CSS_JSAForm';
                    }
                    else if(form.RecordType.Name == 'InShopJSA'){
                        FormType = 'In-Shop JSA';
                        pageName = 'FSL_InShopJSA';
                    }
                    else if(form.RecordType.Name == 'FieldServiceJSA'){
                        FormType = 'Field Service JSA';
                        pageName = 'FSL_FieldServiceJSA';
                    }
                    else if(form.RecordType.Name == 'MarineJSA'){
                        FormType = 'Marine JSA';
                        pageName = 'FSL_MarineJSA';
                    }
                    else if(form.RecordType.Name == 'PowerGenJSA'){
                        FormType = 'Power Gen JSA';
                        pageName = 'FSL_PowerGenJSA';
                    }
                    
                    //Calculate Form Initiation time and Current Time
                    Boolean isActive =  true;
                    Boolean isCompleted = true;
                    if(form.Form_Initiate_Time__c != null){
                        Datetime formStartTime = form.Form_Initiate_Time__c;
                        Long startTime = formStartTime.getTime();
                        Long currentTime  = System.now().getTime();
                        Long milliseconds = currentTime - startTime;
                        Long minutes = milliseconds / (1000*60);
                        Long hours = milliseconds / (1000*60*60);
                        System.debug('::: hours = '+hours);
                        if(minutes < Long.valueOf(System.Label.FSL_FormsTime)) {
                            isCompleted = false; 
                        }
                        System.debug(':::isCompleted = '+isCompleted);
                    }
                    
                    if(form.CreatedById == UserInfo.getUserId()) {
                        isActive = false;
                    } 
                    
                    
                    formWrapperList.add(new formWrapper(form, form.JSA_File_Name__c, form.Id, workOrderId, FormType, pageName, form.Form_Start_Time__c, form.CreatedBy.Name, isActive, isCompleted));
                    system.debug('::: formWrapperList = '+ formWrapperList);
                }
            }
            system.debug('::: Final formWrapperList = '+ formWrapperList);
        } catch(Exception ex) {
            System.debug('::: Exception in fetchFormsDetails - '+ex.getMessage());
            System.debug('::: Exception Stacktrace in fetchFormsDetails - '+ex.getStackTraceString());
        }
        
        return (formWrapperList.size()>0) ? formWrapperList : new List<formWrapper>();
    } 
    
    @AuraEnabled
    public static boolean getFormStatus(String jobId) {
        Boolean isFormActive = true;
        try {
            List<CSS_JobForms__c> formsList = [SELECT Id,Form_Initiate_Time__c FROM CSS_JobForms__c where Id =:JobId];
            System.debug(':::CSS Forms List - '+formsList.size()+' * and * '+formsList);
            if(!formsList.isEmpty() && formsList.size() > 0) {
                for(CSS_JobForms__c form: formsList){
                    system.debug(':::CSS_JobForms '+ form);
                    //Calculate Form Initiation time and Current Time Diff for the Form
                    if(form.Form_Initiate_Time__c != null){
                        Datetime formStartTime = form.Form_Initiate_Time__c;
                        Long startTime = formStartTime.getTime();
                        Long currentTime  = System.now().getTime();
                        Long milliseconds = currentTime - startTime;
                        Long minutes = milliseconds / (1000*60);
                        Long hours = milliseconds / (1000*60*60);
                        System.debug('::: hours = '+hours);
                        if(minutes < Long.valueOf(System.Label.FSL_FormsTime)) {
                            isFormActive = false; 
                        }
                        System.debug('::: isFormActive = '+isFormActive);
                    }
                }
            }
        } catch(Exception ex) {
            System.debug('::: Exception in getFormStatus = '+ex.getMessage());
            System.debug('::: Exception Stack in getFormStatus = '+ex.getStackTraceString());
        }
        return isFormActive;
    }
    
    public class formWrapper{
        @AuraEnabled public CSS_JobForms__c jobforming {get;set;}
        @AuraEnabled public string fileName {get;set;}
        @AuraEnabled public id Wid {get;set;}
        @AuraEnabled public Id jformId {get;set;}
        @AuraEnabled public string Type {get; set;}
        @AuraEnabled public string pgName {get; set;}
        @AuraEnabled public String formStartTime{get;set;}
        @AuraEnabled public String createByName{get;set;}
        @AuraEnabled public Boolean isActive{get;set;}
        @AuraEnabled public Boolean isCompleted{get;set;}
        
        public formWrapper(CSS_JobForms__c jobfor,String JSAFileName,Id formId,Id JobId, string FType, string FpgName, String formStartTime, String createByName, Boolean isActive, Boolean isCompleted){ 
            this.jobforming = jobfor;
            this.fileName = JSAFileName;
            this.Wid = JobId;
            this.jformId = formId;
            this.Type = FType;
            this.pgName =FpgName;
            this.formStartTime = formStartTime;
            this.createByName = createByName;
            this.isActive = isActive;
            this.isCompleted = isCompleted;
        }
    }
}