public class FSLJobClosureFlowCls {
    
    @auraEnabled
    public static Boolean closeWorkOrderFromIntake(String strWorkOrderId, String stageName) {
        try {
            system.debug('stageName>>'+stageName);
            String query= 'Select Id, Status, Sub_Status__c, Process_Step__c, RecordTypeId FROM WorkOrder WHERE Id=:strWorkOrderId LIMIT 1';
            WorkOrder objWorkOrder = Database.query(query);
            RecordType rt = new RecordType();
            System.debug('Intake');
            objWorkOrder.Process_Step__c = 'Close';
            if(stageName == 'Repair'){
                objWorkOrder.Status = 'Closed';
                objWorkOrder.Sub_Status__c = 'Close';
            }
            else{
                objWorkOrder.Status = 'Canceled';
                objWorkOrder.Sub_Status__c = 'Cancel';
            }
            rt=  [SELECT Id,Name 
                  FROM RecordType
                  WHERE SobjectType='WorkOrder' AND developername='Close' LIMIT 1];
            objWorkOrder.RecordTypeId = rt.Id;
            update objWorkOrder;
            return true;
        }
        catch(System.EmailException e)
        {
            return false;
        }
    }
    
    @AuraEnabled
    public static void closeJobFromTndnJPforNoMostLikly(String strWorkOrderId, String stageName, String feedback, String resoln) {
        system.debug('stageName>>'+stageName);
        String query= 'Select Id, Process_Step__c, Status, RecordTypeId, FSL_Feedback_Comments__c, FSL_Resolution__c '+ 
            'FROM WorkOrder WHERE Id=:strWorkOrderId LIMIT 1';
        WorkOrder objWorkOrder = Database.query(query);
        objWorkOrder.FSL_Resolution__c=resoln;
        system.debug('resolution>'+resoln);
        system.debug('feedback>'+feedback);
        objWorkOrder.FSL_Feedback_Comments__c=feedback;
        RecordType rt = new RecordType();
        //added condition for repair - vinod 9.23
        if(objWorkOrder.Process_Step__c == 'Triage & Diagnosis' || 
           objWorkOrder.Process_Step__c == 'Job Plan' || 
           objWorkOrder.Process_Step__c == 'Schedule' ||
          objWorkOrder.Process_Step__c == 'Repair') {
            objWorkOrder.Process_Step__c = stageName;
            objWorkOrder.Status = 'Closed';
            objWorkOrder.Sub_Status__c = 'Close';
            rt=  [SELECT Id,Name 
                  FROM RecordType
                  WHERE SobjectType='WorkOrder' AND developername='Close' LIMIT 1];
            objWorkOrder.RecordTypeId = rt.Id;
        }
        system.debug(objWorkOrder);
        update objWorkOrder;
    }
    
    @AuraEnabled
    public static Boolean closeJobFromTndnJPforMostLikly(String strWorkOrderId, String stageName, List<CSSSolnWrp> cssSolns) {
        system.debug('stageName>>'+stageName);
        Boolean show2OptionsPopup=false;
        String query= 'Select Id,Status,Sub_Status__c, Process_Step__c, RecordTypeId, FSL_Feedback_Comments__c, FSL_Resolution__c '+ 
            'FROM WorkOrder WHERE Id=:strWorkOrderId LIMIT 1';
        WorkOrder objWorkOrder = Database.query(query);        
        RecordType rt = new RecordType();
        List<CSS_Solutions__c> cssSols = new List<CSS_Solutions__c>();
        Boolean isRepairSelected=false;
        Boolean isRepairNotSelected=false;                               //added condition for repair - vinod 9/23
        for(CSSSolnWrp csw : cssSolns)
        {
            
            if(String.isNotBlank(csw.repairResp))
            {
                //added condition for repair - vinod 9/23
               
                if(!isRepairSelected && ( csw.repairResp == 'Repair Successful.' ||
                                         csw.repairResp == 'Repair Successful with additional parts/procedures.'))
                    isRepairSelected = true;
                if(!isRepairNotSelected && !isRepairSelected && ( csw.repairResp == 'Repair performed but didnot resolve the root cause.' ||
                                         csw.repairResp == 'Repair not performed.'))
                    isRepairNotSelected = true;
                cssSols.add(new CSS_Solutions__c(Id=csw.csId, Repair_Response__c=csw.repairResp));
            }
        }
        if(!cssSols.isEmpty())
        {
            try{
                upsert cssSols;    
            } catch(Exception e) {}
            
            if(stageName != 'Repair' && cssSols.size() < 2 && checkForMostLikely(strWorkOrderId) && (objWorkOrder.Process_Step__c=='Job Plan'))
                show2OptionsPopup = true;
            else if(stageName == 'Repair' && isRepairNotSelected)//added condition for repair - vinod 9/23
                show2OptionsPopup = true;
            else if(objWorkOrder.Process_Step__c == 'Triage & Diagnosis' && isRepairNotSelected)
                 show2OptionsPopup = true;
        }
        if(((objWorkOrder.Process_Step__c == 'Triage & Diagnosis' || 
           objWorkOrder.Process_Step__c == 'Repair') && isRepairSelected ) ||
           objWorkOrder.Process_Step__c == 'Job Plan') {
            objWorkOrder.Process_Step__c = 'Close';
            objWorkOrder.Status = 'Closed';
            objWorkOrder.Sub_Status__c = 'Close';  
            rt=  [SELECT Id,Name 
                  FROM RecordType
                  WHERE SobjectType='WorkOrder' AND developername='Close' LIMIT 1];
            objWorkOrder.RecordTypeId = rt.Id;
        }
        system.debug(objWorkOrder);
        update objWorkOrder;
        system.debug('show2OptionsPopup>>'+show2OptionsPopup);
        
        return show2OptionsPopup;
    }
    
    //Added by vinod for stage flow.7/23
    @auraEnabled
    public static String getProcessStatus(String woId)
    {
        String processStatus = [SELECT Id, Process_Step__c FROM workOrder WHERE Id=:woID].Process_Step__c;
        return processStatus;
    }
    //Added by vinod for Stage flow 7/24
    @auraEnabled
    public Static Boolean checkForMostLikely(String woId)
    {
        List<CSS_Solutions__c> cssSols= [select id,FSL_Service_Job__r.recordtype.developername, FSL_Service_Job__r.process_step__c from CSS_Solutions__c where FSL_Service_Job__c=:woId AND
                                         Diagnostic_Response__c='Most likely the solution. Repair recommended.'];
        if(cssSols != null && !cssSols.isEmpty() && 
           (cssSols[0].FSL_Service_Job__r.process_step__c == 'Repair' || cssSols[0].FSL_Service_Job__r.process_step__c == 'Triage & Diagnosis')){
               system.debug('inside if');
               //(cssSols[0].FSL_Service_Job__r.recordtype.developername == 'SolutionT_D' || cssSols[0].FSL_Service_Job__r.recordtype.developername == 'SolutionRepair') ){
            return true;
        } else {
            return false;
        }
    }
    @auraEnabled
    public Static Boolean checkForRepairSelection(String woId)
    {
        List<CSS_Solutions__c> cssSols= [select id,FSL_Service_Job__r.recordtype.developername,FSL_Service_Job__r.process_step__c
                                         from CSS_Solutions__c where FSL_Service_Job__c=:woId AND 
                                         Repair_Response__c in ('Repair Successful.','Repair Successful with additional parts/procedures.'
                                                               )];
        //'Repair performed but didnot resolve the root cause.','Repair not performed.'
        if(cssSols != null && !cssSols.isEmpty() && cssSols[0].FSL_Service_Job__r.process_step__c == 'Repair' ){
            system.debug('Insideif');
            return true;
        }
        else  {
             system.debug('insideelse');
         return false;
        }
    }
    @auraEnabled
    public static List<String> getResolutions()
    {
        List<String> options = new List<String>();        
        Schema.DescribeFieldResult fieldResult = WorkOrder.FSL_Resolution__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }       
        return options;
    }
    
    @auraEnabled
    public static List<String> getRepairRespLOVs()
    {
        List<String> options = new List<String>();        
        Schema.DescribeFieldResult fieldResult = CSS_Solutions__c.Repair_Response__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }
        system.debug('repair resp options>>'+options);
        return options;
    }
    
    @auraEnabled
    public static list<CSSSolnWrp> getSolnDetails(String woId)
    {
        system.debug('get sol details');
        List<CSSSolnWrp> csss = new List<CSSSolnWrp>();
        List<CSS_Solutions__c> cssSols;
        String status=[select process_step__c from workorder where id=:woId].process_step__c;
        //added for repair popup fix - 9/11 by vinod
     //   if(status == 'Triage & Diagnosis')
            cssSols = [select id,Solution_Title__c,Name from CSS_Solutions__c where FSL_Service_Job__c=:woId AND
                                         Diagnostic_Response__c='Most likely the solution. Repair recommended.'];
      /*  else if(status == 'Repair')
            cssSols = [select id,Solution_Title__c,Name from CSS_Solutions__c where FSL_Service_Job__c=:woId AND
                                         Repair_Response__c in ('Repair Successful.','Repair Successful with additional parts/procedures.',
                                                                'Repair performed but didnot resolve the root cause.')]; */
        
        if(cssSols != null && !cssSols.isEmpty())
        {
            for(CSS_Solutions__c cs : csssols)
            {
                csss.add(new CSSSolnWrp(cs.id, cs.Solution_Title__c, cs.Name));
            }
        }
        return csss;
    }
    public class CSSSolnWrp
    {
        @auraEnabled public Id csId{get;set;}
        @auraEnabled public String solName{get;set;}
        @auraEnabled public String solNbr{get;set;}
        @auraEnabled public String repairResp{get;set;}
        public CSSSolnWrp(Id csId, String solNbr, String solName)
        {
            this.csId=csId;
            this.solName=solName;
            this.solNbr=solNbr;
            this.repairResp='';
        }
        public CSSSolnWrp(){}
    }
}