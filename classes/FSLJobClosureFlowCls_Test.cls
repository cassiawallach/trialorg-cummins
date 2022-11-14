@IsTest
public class FSLJobClosureFlowCls_Test {  
    
    static testMethod void createData()
    {
        FSLTestDataSetupCls.createIntegrationConfigs();
        Account a = FSLTestDataSetupCls.createAccountData();
        Asset ast=FSLTestDataSetupCls.createAssetRecord();
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st);
        knowledge__kav knw=new knowledge__kav(urlname='testurl',title='testtitile');
        insert knw; 
        CSS_Solutions__c sol = new CSS_Solutions__c(Solution_Title__c='testSol',Solution__c='Solution1', FSL_Service_Job__c=wo.id, Diagnostic_Response__c='Most likely the solution. Repair recommended.');
        insert sol;
        CSS_Solutions__c so5 = new CSS_Solutions__c(Solution_Title__c='testSol',Solution__c='Solution1', FSL_Service_Job__c=wo.id, Repair_Response__c='Repair Successful.');
        insert so5;
        CSS_Solutions__c sol1 = new CSS_Solutions__c(Solution_Title__c='testSol',Solution__c='Solution1', FSL_Service_Job__c=wo.id, Repair_Response__c='Repair Successful with additional parts/procedures.');
        insert sol1;
        CSS_Solutions__c sol2 = new CSS_Solutions__c(Solution_Title__c='testSol',Solution__c='Solution1', FSL_Service_Job__c=wo.id, Diagnostic_Response__c='Could not perform the solution verification.');
        insert sol2;
        CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c(Solutions__c=sol.id, Fault_Code__c='test123');
        insert solcmp;
        CSS_Parts_Options__c solpart= new CSS_Parts_Options__c(Solutions__c=sol.id, FailurepartId__c=solcmp.id);
        insert solpart;
        update wo;
        
    } 
   static testMethod void fsljobclosure1(){
        createData();
        workorder objwo = [SELECT Id,RecordTypeId, Process_Step__c
                           FROM WorkOrder];
        List<CSS_Solutions__c> soln = [select id, Solution_Title__c,Repair_Response__c,Name From CSS_Solutions__c ];
        FSLJobClosureFlowCls.closeWorkOrderFromIntake(objwo.id, 'Close');
        FSLJobClosureFlowCls.closeWorkOrderFromIntake(objwo.id, 'Repair');
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        objwo.Process_Step__c='Triage & Diagnosis';
       
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Job_Plan').getRecordTypeId();
        objwo.Process_Step__c='Job Plan';
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Schedule').getRecordTypeId();
        objwo.Process_Step__c='Schedule';
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        objwo.Process_Step__c='Repair';
        // wo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Close').getRecordTypeId();
        //  wo.Process_Step__c='Close';
        update objwo;
        FSLJobClosureFlowCls.closeJobFromTndnJPforNoMostLikly(objwo.Id, 'Close', 'test','Resolved by Campaign, TRP, or TSB');
        
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionRepair').getRecordTypeId();
        objwo.Process_Step__c='Repair';
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Schedule').getRecordTypeId();
        objwo.Process_Step__c='Schedule';
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        objwo.Process_Step__c='Repair';
        // wo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Close').getRecordTypeId();
        //  wo.Process_Step__c='Close';
        
        update objwo;
        FSLJobClosureFlowCls.checkForRepairSelection(objwo.id);
        FSLJobClosureFlowCls.getProcessStatus(objwo.id);
        FSLJobClosureFlowCls.getResolutions();
        FSLJobClosureFlowCls.getRepairRespLOVs();
        FSLJobClosureFlowCls.checkForMostLikely(objwo.Id);	
        FSLJobClosureFlowCls.closeJobFromTndnJPforMostLikly(objwo.Id, 'Repair', FSLJobClosureFlowCls.getSolnDetails(objwo.id));
        //FSLJobClosureFlowCls.closeJobFromTndnJPforMostLikly(objwo.Id, 'Repair', soln );
         
       //sol.Diagnostic_Response__c='';
        //update sol;      

    }   


    static testMethod void fsljobclosure2(){
        createData();
        workorder objwo = [SELECT Id,RecordTypeId, Process_Step__c, AssetId
                           FROM WorkOrder];
        List<CSS_Solutions__c> soln = [select id, Solution_Title__c,Repair_Response__c,Name From CSS_Solutions__c ];
        //FSLJobClosureFlowCls.closeWorkOrderFromIntake(objwo.id, 'Close');
        FSLJobClosureFlowCls.closeWorkOrderFromIntake(objwo.id, 'Repair');
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        objwo.Process_Step__c='Triage & Diagnosis';
       
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Job_Plan').getRecordTypeId();
        objwo.Process_Step__c='Job Plan';
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Schedule').getRecordTypeId();
        objwo.Process_Step__c='Schedule';
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        objwo.Process_Step__c='Repair';
        // wo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Close').getRecordTypeId();
        //  wo.Process_Step__c='Close';
        update objwo;
        FSLJobClosureFlowCls.closeJobFromTndnJPforNoMostLikly(objwo.Id, 'Close', 'test','Resolved by Campaign, TRP, or TSB');
        
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionRepair').getRecordTypeId();
        objwo.Process_Step__c='Repair';
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Schedule').getRecordTypeId();
        objwo.Process_Step__c='Schedule';
        objwo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        objwo.Process_Step__c='Repair';
        // wo.RecordTypeId= Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Close').getRecordTypeId();
        //  wo.Process_Step__c='Close';
        
        update objwo;
        FSLJobClosureFlowCls.checkForRepairSelection(objwo.id);
        FSLJobClosureFlowCls.getProcessStatus(objwo.id);
        FSLJobClosureFlowCls.getResolutions();
        FSLJobClosureFlowCls.getRepairRespLOVs();
        FSLJobClosureFlowCls.checkForMostLikely(objwo.Id);  
        FSLJobClosureFlowCls.closeJobFromTndnJPforMostLikly(objwo.Id, 'Repair', getSolnDetails(soln));
        //FSLJobClosureFlowCls.closeJobFromTndnJPforMostLikly(objwo.Id, 'Repair', soln );
        //FSLJobClosureFlowCls.closeJobFromTndnJPforMostLikly(objwo.Id, 'Repair', FSLJobClosureFlowCls.getSolnDetails(objwo.id));

         
       //sol.Diagnostic_Response__c='';
        //update sol;      

    }   


    public static list<FSLJobClosureFlowCls.CSSSolnWrp> getSolnDetails(List<CSS_Solutions__c> cssSols)
    {
        system.debug('get sol details');
        List<FSLJobClosureFlowCls.CSSSolnWrp> csss = new List<FSLJobClosureFlowCls.CSSSolnWrp>();
        FSLJobClosureFlowCls.CSSSolnWrp temp1 = new FSLJobClosureFlowCls.CSSSolnWrp();
        
        if(cssSols != null && !cssSols.isEmpty())
        {
            for(CSS_Solutions__c cs : csssols)
            {
                
                FSLJobClosureFlowCls.CSSSolnWrp temp = new FSLJobClosureFlowCls.CSSSolnWrp(cs.id, cs.Solution_Title__c, cs.Name);
                temp.repairResp = cs.Repair_Response__c;
                csss.add(temp);
                
            }
        }
        return csss;
    }


   
}