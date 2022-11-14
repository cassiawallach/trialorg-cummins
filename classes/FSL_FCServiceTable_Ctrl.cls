public class FSL_FCServiceTable_Ctrl {
    
    //added by sriprada
    @AuraEnabled
    public static void changeRecord(string workId,string faultID)
    {
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
            .get('SolutionT_D').getRecordTypeId();
        
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c, RecordTypeId from WorkOrder where id=: workId];
        if(wo1.size() > 0){
            if(wo1[0].Process_Step__c == 'Repair'){
                recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
                    .get('SolutionRepair').getRecordTypeId();
            }
        }
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, Service_Order_Id__c, FaultCodeId__c ,RecordTypeId from Service_Order_Extension__c where Service_Order_Id__c =: workId];
        
        Service_Order_Extension__c worExtn = new Service_Order_Extension__c();
        worExtn.Id       	 	= woExtList[0].id;
        worExtn.FaultCodeId__c  	= faultID;
        if(woExtList.size() > 0){
            update worExtn;
        }
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
        {
            WorkOrder wo = new WorkOrder();
            wo.Id = workId;
            wo.RecordTypeId = recdtypeId;
            update wo;   
        }    
        
        /* string solname = '';
        String solutionId = '';
        for(CSS_Solutions__c sol :[select name from CSS_Solutions__c where Id =:solutionId])
        {
        solname = sol.name;
        }        
        list<Knowledge__kav> knwList = new list<Knowledge__kav>();
        knwList = [Select Id,UrlName,Validations__c,Verification__c,Repairs__c from Knowledge__kav where UrlName =:solname];
        
        update knwList;*/
        
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
        wo.RecordTypeId = recdtypeId;
        wo.Process_Step__c = 'Repair';
        system.debug('::: WorkOrder to update  - '+wo);
        
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, Service_Order_Id__c, FaultCodeId__c ,RecordTypeId from Service_Order_Extension__c where Service_Order_Id__c =: workId];
        
        Service_Order_Extension__c worExtn = new Service_Order_Extension__c();
       
        if(woExtList.size() > 0){
            worExtn.Id = woExtList[0].Id;
            worExtn.FaultCodeId__c = sol.FaultCode__c;
            worExtn.selectedsolution__c = solname;
            
            update worExtn;
        }
       
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
        {
            update wo;   
        }
        //woselecomnull(wo.id);
        return solname;
       
    }   
  
}