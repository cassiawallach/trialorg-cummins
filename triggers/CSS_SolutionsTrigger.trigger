trigger CSS_SolutionsTrigger on CSS_Solutions__c (after update,after insert) {    
    
    //Logic to invoke Handler class to assign Sequence
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            
            CSS_SolutionsTriggerHandler.assignSequence(Trigger.New, Trigger.oldMap);
        }
        if(Trigger.isInsert){
            CSS_SolutionsTriggerHandler.assignTakeControlOnWO(Trigger.New);
        }
    }
    //****************** This is for GUIDANZ*******************/
    boolean guidanzFlag = false;
    for(CSS_Solutions__c sol : Trigger.New) {
        if(sol.CSS_Classic_SJId__c != null && sol.CSS_Classic_SJId__c != '') {
            guidanzFlag = true;
            break;
        }
    }  
    //****************** This is for GUIDANZ*******************/
    if(guidanzFlag) {
        system.debug('Kal**'+Trigger.new);
        List<CSS_Solutions__c> name = [select Service_Job__r.Name,Service_Job__r.Claim_no__c,Service_Job__r.Accesscode__c from CSS_Solutions__c where id in:Trigger.new];
        if(trigger.isUpdate){
             List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
                claimsAuditLst = [SELECT Id, Action_Type__c,isServicejob__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                                  FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Solutions__c' ORDER BY Sort_Order__c ASC];
             CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(Trigger.new,trigger.oldmap, claimsAuditLst);
            System.debug('claimsAuditLst'+claimsAuditLst);
            system.debug('Kal**'+Trigger.new);
            //varibale for FaultCode ids.
            set<Id> faultCodeId = new set<Id>();
            List<string> solDiagAdd = new List<string>();
            List<string> solRepAdd = new List<string>();
            List<CSS_Solutions__c> solutions = Trigger.new;
            Map<ID,ID> jobOrder = new Map<ID,ID>();
            Map<ID,String> solName = new Map<ID,String>();
            string serviceModel;
            for(CSS_Solutions__c sol:solutions){
                if(sol.Solution_Title__c!=null && sol.Service_Job__c!=null && sol.Name!=null && sol.Diagnostic_Response__c!=null && sol.Service_Model__c!=null){
                    if((trigger.oldMap.get(sol.Id).Diagnostic_Response__c==null && sol.Diagnostic_Response__c!=null) || (trigger.oldMap.get(sol.Id).Diagnostic_Response__c!='Most likely the solution' && sol.Diagnostic_Response__c=='Most likely the solution')){//This OR condition line is added since on soln update from Couldn't Perform Soln to Most likely Soln, service was not calling
                        jobOrder.put(sol.ID,sol.Service_Job__c);
                        System.debug('The job order inside trigger is'+jobOrder);
                        solName.put(sol.ID,sol.Name);
                        serviceModel = sol.Service_Model__c;
                    }
                }
                if(sol.Diagnostic_Response__c!=trigger.oldMap.get(sol.Id).Diagnostic_Response__c && sol.Diagnostic_Response__c!=null ){
                    solDiagAdd.add(JSON.Serialize(new solWrapper(sol.Diagnostic_Response__c,sol.Name,sol.Diagnostic_notes__c,sol.DSID__c)));
                }
                if(sol.Repair_Response__c!=trigger.oldMap.get(sol.Id).Repair_Response__c && sol.Repair_Response__c!=null ){
                    solRepAdd.add(JSON.Serialize(new solWrapper(sol.Repair_Response__c,sol.Name,sol.Repair_Notes__c,sol.DSID__c)));
                }
                if(sol.out_of_order__c){
                    faultCodeId.add(sol.FaultCode__c);
                }
                
            }
            CSS_DataExchangeHelper deHelper = new CSS_DataExchangeHelper();
            deHelper.insertDataExchangeSolution(trigger.new,trigger.oldmap);
            if(!Test.isRunningTest()){
                System.debug('The size inside update is'+solRepAdd.size()+'  '+solDiagAdd.size());
                System.debug('The content inside update is'+solRepAdd+'  '+solDiagAdd);
                //CSS_EDSActionsUpdate.caseRepStatusUpdate(solRepAdd);    
                //CSS_EDSActionsUpdate.caseDiagStatusUpdate(solDiagAdd);    
                CSS_SRT.diagnosticSRT(jobOrder,solName,serviceModel,name[0].Service_Job__r.Name,name[0].Service_Job__r.Claim_no__c,name[0].Service_Job__r.Accesscode__c);
            }
            
            if(faultCodeId != null && !faultCodeId.isEmpty()){
                list<CSS_Fault_Code__c> faultCodeList = [Select Id,PoleMessage__c 
                                                         from CSS_Fault_Code__c where Id IN : faultCodeId];
                
                if(faultCodeList != null && !faultCodeList.isEmpty()){
                    for(CSS_Fault_Code__c faultCodeRec : faultCodeList){
                        faultCodeRec.PoleMessage__c = TRUE;
                    }
                }
                
                {
                    update faultCodeList;
                }   
            } 
        }
        if(trigger.isInsert){
            
            System.debug('Inside insert');
            set<Id> faultCodeId = new set<Id>();
            List<string> solDiagAdd = new List<string>();
            List<string> solRepAdd = new List<string>();
            List<CSS_Solutions__c> solutions = Trigger.new;
            Map<ID,ID> jobOrder = new Map<ID,ID>();
            Map<ID,String> solName = new Map<ID,String>();
            string serviceModel;
            for(CSS_Solutions__c sol:solutions){
                System.debug('The solution is'+sol);
                if(sol.Solution_Title__c!=null && sol.Service_Job__c!=null && sol.Name!=null && sol.Diagnostic_Response__c!=null && sol.Service_Model__c!=null){
                    if(sol.Diagnostic_Response__c!=null){
                        jobOrder.put(sol.ID,sol.Service_Job__c);
                        solName.put(sol.ID,sol.Name);
                        serviceModel = sol.Service_Model__c;
                    }
                }
                if(sol.Diagnostic_Response__c!=null && sol.CSS_Nested_Solutions__c!=null ){
                    solDiagAdd.add(JSON.Serialize(new solWrapper(sol.Diagnostic_Response__c,sol.Name,sol.Diagnostic_notes__c,sol.DSID__c)));
                }
                if(sol.Repair_Response__c!=null && sol.CSS_Nested_Solutions__c!=null ){
                    solRepAdd.add(JSON.Serialize(new solWrapper(sol.Repair_Response__c,sol.Name,sol.Repair_Notes__c,sol.DSID__c)));
                }
                if(sol.out_of_order__c){
                    faultCodeId.add(sol.FaultCode__c);
                }
            }
            if(!Test.isRunningTest()){
                System.debug('The size inside insert is'+solRepAdd.size()+'  '+solDiagAdd.size());
                System.debug('The content inside insert is'+solRepAdd+'  '+solDiagAdd);
                //CSS_EDSActionsUpdate.caseRepStatusUpdate(solRepAdd);    
                // CSS_EDSActionsUpdate.caseDiagStatusUpdate(solDiagAdd);    
                CSS_SRT.diagnosticSRT(jobOrder,solName,serviceModel,name[0].Service_Job__r.Name,name[0].Service_Job__r.Claim_no__c,name[0].Service_Job__r.Accesscode__c);
            } 
        }
        
    }
    
    public class solWrapper{
        public string solNum{get;set;}
        public string status{get;set;}
        public string comment{get;set;}
        public string dsid{get;set;}  
        public solWrapper(string status,string solNum,string comment,string dsid){
            this.solNum = solNum;
            this.status = status;
            this.comment = comment;
            this.dsid=dsid;
        }
    }
}