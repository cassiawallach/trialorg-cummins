/*
*Author: Sruthi
*Description: Controller class for EVL_TDS lightning component
*/
public class EVL_TDSController {
    
    //Method to pull the work order record based on the record ID
    @AuraEnabled
    public static WorkOrder fetchWORecord(String recordId){
        
        return [Select Id, Status from WorkOrder where Id =: recordId LIMIT 1];
    }
    
    @AuraEnabled
    public static Boolean fetchTakeControl(string strjobId){
        
        Boolean isDisplayOptions = false;
        
        User usObj = [Select Id, User_Location__c, Profile.Name, Profile.Id from User where Id =:userInfo.getUserId() LIMIT 1];
        
        List<String> profileNames = new List<String>();
        profileNames.addAll(System.Label.EVL_Profile.split(';'));
        
        WorkOrder wo = [Select Id, User__c, CreatedById, Service_Location_Code__c, EVL_Assigned_Technician__c from WorkOrder where Id =: strJobId LIMIT 1];
        
        Boolean isSolution = FALSE;
        
        for(css_solutions__c sol : [Select Id from css_solutions__c where FSL_Service_Job__c =: strJobId LIMIT 1]){
            isSolution = TRUE;
        }
        
        if(!Test.isRunningTest() && (!isSolution || wo.EVL_Assigned_Technician__c == NULL || wo.EVL_Assigned_Technician__c == '')){
            //    return true; //Commented on 1/5/22 by Piyush for VGRS2-95
        }
        
        if(wo.User__c != NULL){
            if(wo.User__c == usObj.Id){
                isDisplayOptions = true;
            }
        }
        else if(wo.CreatedById == usObj.Id || (profileNames.contains(usObj.Profile.Name) && wo.Service_Location_Code__c == usObj.User_Location__c)){
            isDisplayOptions = true;    
        } 
        //Condition added on 1/5/22 by Piyush for VGRS2-95
        else if(wo.CreatedById != usObj.Id || (!profileNames.contains(usObj.Profile.Name) && (usObj.UserRoleName__c == 'factory'))){
            isDisplayOptions = true;
        } 
        //End VGRS2-95
        system.debug('isDisplayOptions'+isDisplayOptions);
        return isDisplayOptions;
    }
    
    // Copied from EVL_CL_ServiceOrder_LightningPath class for status check -- Sriprada
    
    @AuraEnabled
    public static Boolean recordStatus(string recId){
        system.debug('recId==>'+recId);
        boolean showRecord = false;        
        workorder wo = [select id, status, EVL_Stage__c from workorder where id =: recId];
        if(wo.Status != 'Closed' && wo.EVL_Stage__c != 'Closed' ){
            showRecord = true;
        }
        return showRecord;
    }
    
    //Methods added by Sriprada for VGRS2-6 : 10/20/2021 
    @AuraEnabled
    public static Boolean fetchFCData(String recordId){
        Boolean fcCount;
        CSS_Fault_Code__c[]  fc = [Select Id, Name from CSS_Fault_Code__c where Service_Order__c =: recordId LIMIT 1];
        if(fc.size() > 0){
            fcCount = true;
        } 
        else{
            fcCount = false;
        }
        return fcCount;
    }
    
    
    @AuraEnabled
    public static Boolean fetchSolData(String recordId){
        Boolean fcCount;
        WorkOrder[]  wo = [Select Id,Service_Order_Extension__r.FaultCodeId__c from WorkOrder where id =: recordId LIMIT 1];
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: recordId ];
        String FCId = woExtList[0].FaultCodeId__c;
        
        CSS_Solutions__c[] cs=[SELECT Repair_Response__c FROM CSS_Solutions__c WHERE FSL_Service_Job__c=:recordId 
                               and FSL_Service_Job__r.Type__c = 'Dealer'  AND Diagnostic_Response__c='Most likely the solution. Repair recommended.'
                               AND FaultCode__c =:FCId Limit 1];        
        if(cs.size() > 0){
            fcCount = true;
        } 
        else{
            fcCount = false;
        }
        return fcCount;
    }
    
    @AuraEnabled
    public static Boolean fetchFCSolData(String recordId){
        Boolean fcCount;
        WorkOrder[]  wo = [Select Id, Service_Order_Extension__c, Service_Order_Extension__r.FaultCodeId__c from WorkOrder where id =: recordId LIMIT 1];
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: recordId ];
        String FCId = woExtList[0].FaultCodeId__c;
        
        if(woExtList.size() >= 0 && woExtList[0].FaultCodeId__c != null){
            fcCount = true;
        } 
        else{
            fcCount = false;
        }
        return fcCount;
    } // Code ends here -- Sriprada
    
    //Priyanka for VGRS2-15 generic method for future reusability purpose
    @AuraEnabled
    public static response_Wrapper getUserDetails () {
        response_Wrapper response = new response_Wrapper();
        Id userId = userinfo.getUserId();
        User userInfo =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
        response.userDetails = userInfo;
        return response;
    }
    
    // Added by shirisha 08/25/2022 ROAD-556
    @AuraEnabled
    public static Boolean fetchFTRFlag(Id woId){
        try{
            Service_Order_Extension__c soExtensionObj = [SELECT Id, FSL_ABRFlag__c, Service_Order_Id__c FROM Service_Order_Extension__c WHERE Service_Order_Id__c =: woId LIMIT 1];
            Boolean flag = soExtensionObj.FSL_ABRFlag__c;
            if(flag != null){
                return flag;
            }
            else {
                return false;
            }
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public class response_Wrapper {
        
        @auraEnabled public String profileName{get;set;}
        @auraEnabled public boolean isSuccess{get;set;}
        @auraEnabled public string errorMessage  {get;set;}
        @auraEnabled public user  userDetails  {get;set;}
        
        public response_Wrapper(){
            this.isSuccess = true;
            this.errorMessage = '';                   
            this.userDetails = new user();
        }
        
    } 
    
}