/**********************************************************************
Name:FSL_Update_Cause
Copyright © 2011  Cummins
=======================================================================
=======================================================================
Purpose:                                                            
To perform all the Functionalties of Job Plan                                                          
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE             DETAIL                                 
1.0 - Vinod Yellala      03/11/2019       INITIAL DEVELOPMENT
***********************************************************************/
public class FSL_Update_Cause {
    @InvocableMethod(label='FSLupdateCause' description='updateCause from Process Builder')
    public static void FSLupdateCause(List<Id> solId){
        
        List<WorkOrder> fslWOs=new List<WorkOrder>();
        WorkOrder fslWO;//=new WorkOrder();
        List<CSS_Solutions__c> lstSolutions;
        system.debug('solId: '+solId);
        //added FSL_Service_Job__c on SOQL by vinodo yellala FSL 4C's
        lstSolutions = [Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c,FSL_Service_Job__c,
                        Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c,FaultCode__r.name,
                        (select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c 
                         from CSS_Solution_Components__r  where Selected_Component__c=TRUE)
                        from CSS_Solutions__c where Id = :solId ];//removed check and CSS_Nested_Solutions__c = null from 9/6 - by vinod
        if(!lstSolutions.isEmpty() && lstSolutions.size()>0)
        {
            //Starts added by vinod 6/3 for 4C's on FSL
            
            fslWOs=[Select Id,WorkOrderNumber,EditCause__c from Workorder where id= :lstSolutions[0].FSL_Service_Job__c];//added by vinod 6/3 for 4C's on FSL
            
            if(fslWOs.size()>0)
                fslWO=fslWOs[0];
            if(String.isBlank(fslWO.EditCause__c))
                fslWO.EditCause__c='';
            //Ends added by vinod 6/3 for 4C's on FSL
            List<CSS_Solutions__c> NestedSOls=[Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c,
                                               Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c, FaultCode__r.name,(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c from CSS_Solution_Components__r),CSS_Nested_Solutions__c
                                               from CSS_Solutions__c where CSS_Nested_Solutions__c IN :lstSolutions];            
            String SolCompToBMS='';
            String SolResponse='';
            String BMSFailureID='';
            String NestSolCompToBMS='';
            String NestSolResponse='';
            String NestBMSFailureID='';
            system.debug('fslWO>>'+fslWO);
            Map<Id,List<CSS_Solutions__c>> mapSolNested=new Map<Id,List<CSS_Solutions__c>>();        
            for(CSS_Solutions__c sol:NestedSOls){
                if(mapSolNested.containsKey(sol.CSS_Nested_Solutions__c)){
                    mapSolNested.get(sol.CSS_Nested_Solutions__c).add(sol);
                }else{
                    mapSolNested.put(sol.CSS_Nested_Solutions__c, new List<CSS_Solutions__c>{sol});
                }
            }
            system.debug('mapSolNested: '+mapSolNested);
            for(CSS_Solutions__c solutions : lstSolutions)
            {
                system.debug('solutions.Diagnostic_Response__c>>'+solutions.Diagnostic_Response__c);
                NestSolCompToBMS = ''; 
                NestSolResponse = '';
                BMSFailureID = '';
                //modified by vinod yellala 6-3 to add 2nd value check on diagnostic response
                if(solutions.Diagnostic_Response__c != null && 
                   (solutions.Diagnostic_Response__c.equalsIgnoreCase('Most likely the solution') ||
                    solutions.Diagnostic_Response__c.equalsIgnoreCase('Most likely the solution. Repair recommended.')))
                {
                    if(fslWO != null)
                    {
                        //SolResponse = '\n' + 'Solution Title' + '=' + solutions.Solution_Title__c + '\n' + 'Diagnostic Notes' + '=' + solutions.Diagnostic_notes__c;
                        SolResponse += '\n' + solutions.FaultCode__r.name +  '\nDiagnostic Notes' + ': ' + solutions.Diagnostic_notes__c +'\n' ;
                        if(solutions.CSS_Solution_Components__r != null){
                            system.debug('solutions.CSS_Solution_Components__r size:'+solutions.CSS_Solution_Components__r.size());
                            for(CSS_Solution_Component__c components : solutions.CSS_Solution_Components__r){
                                if(components.Selected_Component__c)
                                {
                                    SolResponse +='Root Cause:'+components.name+'\n';
                                    BMSFailureID = BMSFailureID;
                                }
                            }
                        }
                        if(mapSolNested.containsKey(solutions.Id)){
                            for(CSS_Solutions__c nestedSol : mapSolNested.get(solutions.Id)){
                                //modified by vinod yellala 6-3 to add 2nd value check on diagnostic response
                                if(nestedSol.Diagnostic_Response__c != null && 
                                   (nestedSol.Diagnostic_Response__c.equalsIgnoreCase('Most likely the solution') ||
                                    nestedSol.Diagnostic_Response__c.equalsIgnoreCase('Most likely the solution. Repair recommended.'))){
                                        NestSolResponse = '\n' + 'Diagnostic Notes' + ':' + nestedSol.Diagnostic_notes__c + 'Root Cause' + ':' + nestedSol.Solution_Title__c + '\n';
                                        if(nestedSol.CSS_Solution_Components__r != null){
                                            for(CSS_Solution_Component__c components : nestedSol.CSS_Solution_Components__r){
                                                NestBMSFailureID = NestBMSFailureID + '';
                                            }
                                        }
                                        NestSolCompToBMS = NestSolCompToBMS + '\n' + NestSolResponse + '\n' + NestBMSFailureID;
                                    }
                            }
                        }
                        SolCompToBMS = SolCompToBMS + '\n' + SolResponse + '\n' + NestSolCompToBMS + '\n' + BMSFailureID;
                    }
                }
            }
            
            String cause;
            if(fslWO != null)
            {
                //cause = (fslWO.EditCause__c == null)?'':fslWO.EditCause__c.replace('\n' + 'Service Order' + '=' + fslWO.WorkOrderNumber, '');//added by vinod 6/3 for 4C's on FSL
                fslWO.EditCause__c += SolCompToBMS + '\n' + '\n';//added by vinod 6/3 for 4C's on FSL
                system.debug('fslWO.EditCause__c>>'+fslWO.EditCause__c);
                update fslWO;//added by vinod 6/3 for 4C's on FSL
            }
        }
    }
}