public class EVL_FCServiceTable_Ctrl {
 //added by sriprada
    @AuraEnabled
    public static string changeRecord(string workId,string faultID,string TabName)
    {
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
            .get('SolutionT_D').getRecordTypeId();
        
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c,AssetId,Asset.Make__c,Asset.Model__c, Asset.Equipment_Id__c, RecordTypeId from WorkOrder where id=: workId];
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: workId];
        
        Service_Order_Extension__c woExt 		= new Service_Order_Extension__c();
        woExt.Id       	 	= woExtList[0].id;
        woExt.FaultCodeId__c  	= faultID;
       /* commenting this for VGRS2-201 by Priyanka
         if(TabName == 'Triage & Diagnosis'){
            WO.Status = 'Triage & Diagnosis'; 
            WO.Process_Step__c = 'Triage & Diagnosis';
            WO.EVL_Stage__c = 'Triage & Diagnosis';
        } 
        else  
 			if(TabName == 'Repair'){
            WO.Status = 'Repair';
            WO.Process_Step__c = 'Repair';
            WO.EVL_Stage__c = 'Repair';
        } */
        system.debug('to update wo '+woExt);
        system.debug('to update woValues '+wo1[0].Asset.Make__c+wo1[0].Asset.Model__c+wo1[0].Asset.Equipment_Id__c);
        
        /* Added by Sriprada for POC of MakeModel lockdown before proceeding to Troubleshooting*/
        String errMsg;
        if(string.isBlank(wo1[0].Asset.Make__c) && string.isBlank(wo1[0].Asset.Model__c) && string.isBlank(wo1[0].Asset.Equipment_Id__c)){
            system.debug('to update wo '+errMsg);
            
            errMsg = 'No data';
        }
        else if(string.isNotBlank(workId) && string.isNotBlank(wo1[0].Asset.Make__c) && string.isNotBlank(wo1[0].Asset.Model__c) && string.isNotBlank(wo1[0].Asset.Equipment_Id__c))
        {
            errMsg = 'Success';
            update woExt;   
        }    
        system.debug('to update wo '+errMsg);
        
        return errMsg; /* Code ends here --- Sriprada */
        
    }
    
    
    @AuraEnabled
    Public static list<Knowledge__kav> getknowledge(String solutionId)
    {
        string solname = '';
        string solTitle = '';
        for(CSS_Solutions__c sol :[select name,Solution_Title__c from CSS_Solutions__c where Id =:solutionId])
        {
            solname = sol.name;
            solTitle = sol.Solution_Title__c;
        }        
        list<Knowledge__kav> knowledgeList = new list<Knowledge__kav>();
        knowledgeList = [Select Id,UrlName,Validations__c,Verification__c,Repairs__c from Knowledge__kav where UrlName =:solname];
        
        return knowledgeList;
    }
    
    @AuraEnabled
    public static string changesolRecord(string workId,string solId)
    {
        System.debug('::: WorkOrderId and Sol Id - '+workId+' and '+solId);
        string solname='';
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionRepair').getRecordTypeId();
        
        CSS_Solutions__c sol=[SELECT id,name,FSL_Service_Job__c,FaultCode__c,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Notes__c,Repair_Response__c,Repair_Notes__c,Diagnostic_Response__c,userTimestamp__c, 
                              CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.userTimestamp__c FROM CSS_Solutions__c where Id =:solId ORDER BY FSL_Solution_Position__c];
        String position = sol.FSL_Solution_Position__c;
        String subString = position.substringAfter('.');
        system.debug('::: subString = '+subString);
        
        if(subString.length() > 0) {
            
            solname ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t' +sol.FSL_Solution_Position__c+'  '+sol.Solution_Title__c;
            
            system.debug('::: solname = '+solname);
        } 
        else{
            solname = sol.FSL_Solution_Position__c+'\r\t\r\t\r '+sol.Solution_Title__c;
        }
        system.debug('::: solname w/o substring = '+solname);
        WorkOrder wo = [Select id,Process_Step__c, RecordTypeId from WorkOrder where id=: workId LIMIT 1];

        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, Service_Order_Id__c, Selectedsolution__c, Service_Order_Id__r.EVL_Solution_Marked_Most_Likely__c, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: workId];
        
        Service_Order_Extension__c extn = new Service_Order_Extension__c();
        if(woExtList.size() > 0){
            extn.Id = woExtList[0].Id;
            extn.FaultCodeId__c = sol.FaultCode__c;
            extn.Selectedsolution__c = solname;
            // wo.Process_Step__c = 'Repair';
            // wo.EVL_Stage__c = 'Repair';
            //  wo.Status = 'Repair';
            system.debug('::: WorkOrder to update  - '+extn);
            if(string.isNotBlank(workId))
            {
                update extn;   
            }
        }
        
        if(string.isNotBlank(workId))
        {
            wo.EVL_Solution_Marked_Most_Likely__c = true;
            update wo;   
        }

        //woselecomnull(wo.id);
        return solname;
       
    }
    
    //Method to get Product Mileage and Product Hours part of Reload Error fix (NIN-40)
    @AuraEnabled
    public static string validateProductOnWO(string workOrderId){
        
        WorkOrder woObj = [Select Id, Mileage__c, CSS_Hours__c, Application__c from WorkOrder where Id =: workOrderId LIMIT 1];
        
        //Assign App Code by splitting based on '-' and derive appflag to populate mileage and mileage measure afterwards.
        String AutomotiveAppFlag;
        if(woObj.Application__c != null  && woObj.Application__c.contains('-')) {
            String[] AppCode = woObj.Application__c.split('-');
            if(AppCode != null && AppCode.size()>0){
                switch on AppCode[0].trim() {
                    when '130','210','220','310','320','410'{
                        AutomotiveAppFlag = 'Y';
                    }
                    when else{
                        AutomotiveAppFlag = 'N';
                    }
                }
            }
        } 
        
        if(AutomotiveAppFlag == 'Y' && (woObj.Mileage__c == NULL || woObj.Mileage__c < 0)){
            return 'mileagerror';
        }
        else if(AutomotiveAppFlag == 'N' && (woObj.CSS_Hours__c == NULL || woObj.CSS_Hours__c < 0)){
            return 'hourserror';
        }
        else{
            return 'success';
        }
        
    }
    
    //Method to update Product Mileage and Product Hours NIN-40
    @AuraEnabled
    public static void updateWO(String workOrderId, Double hours, Double mileage){
        
        WorkOrder wo = new WorkOrder(Id = workOrderId);
        if(hours != NULL){
            wo.CSS_Hours__c = hours;
        }
        if(mileage != NULL){
            wo.Mileage__c = mileage;
        }
        update wo;
    }
}