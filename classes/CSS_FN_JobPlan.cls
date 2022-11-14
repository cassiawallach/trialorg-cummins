/**********************************************************************
Name:CSS_FN_JobPlan
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
1.0 - Anirudh          	11/30/2016          INITIAL DEVELOPMENT
***********************************************************************/

public class CSS_FN_JobPlan {
      @InvocableMethod(label='updateCause' description='updateCause from Process Builder')
    public static void updateCause(List<Id> solId){
        CSS_Job_Order__c workJob;
        List<CSS_Solutions__c> lstSolutions;
        system.debug('solId: '+solId);
        lstSolutions = [Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c,
                        Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c,(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c from CSS_Solution_Components__r)
                        from CSS_Solutions__c where Id = :solId and CSS_Nested_Solutions__c = null];
        if(!lstSolutions.isEmpty() && lstSolutions.size()>0){
        workJob=[Select Id,Name,EditCause__c from CSS_Job_Order__c where id= :lstSolutions[0].Service_Job__c];
        List<CSS_Solutions__c> NestedSOls=[Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c,
                                           Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c,(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c from CSS_Solution_Components__r),CSS_Nested_Solutions__c
                                           from CSS_Solutions__c where CSS_Nested_Solutions__c IN :lstSolutions];
            
            String SolCompToBMS='';
            String SolResponse='';
            String BMSFailureID='';
            String NestSolCompToBMS='';
            String NestSolResponse='';
            String NestBMSFailureID='';        
            Map<Id,List<CSS_Solutions__c>> mapSolNested=new Map<Id,List<CSS_Solutions__c>>();        
            for(CSS_Solutions__c sol:NestedSOls){
                if(mapSolNested.containsKey(sol.CSS_Nested_Solutions__c)){
                    mapSolNested.get(sol.CSS_Nested_Solutions__c).add(sol);
                }else{
                    mapSolNested.put(sol.CSS_Nested_Solutions__c, new List<CSS_Solutions__c>{sol});
                }
            }
            system.debug('mapSolNested: '+mapSolNested);
            for(CSS_Solutions__c solutions : lstSolutions){
                NestSolCompToBMS = ''; 
                NestSolResponse = '';
                BMSFailureID = '';
                if(solutions.Diagnostic_Response__c != null && solutions.Diagnostic_Response__c.equalsIgnoreCase('Most likely the solution')){
                    SolResponse = 'SolutionID' + '=' + solutions.Name + '\n' + 'Solution Title' + '=' + solutions.Solution_Title__c + '\n' + 'DSID' + '=' + solutions.DSID__c + '\n' + 'Diagnostic Notes' + '=' + solutions.Diagnostic_notes__c;
                    if(solutions.CSS_Solution_Components__r != null){
                        for(CSS_Solution_Component__c components : solutions.CSS_Solution_Components__r){
                            BMSFailureID = BMSFailureID + '\n' + 'Failure Name' + '=' + components.Name + '\n' + 'Failure ID' + '=' + components.Component_Id__c;
                        }
                    }
                    if(mapSolNested.containsKey(solutions.Id)){                  
                        for(CSS_Solutions__c nestedSol : mapSolNested.get(solutions.Id)){
                            if(nestedSol.Diagnostic_Response__c != null && nestedSol.Diagnostic_Response__c.equalsIgnoreCase('Most likely the solution')){
                                NestSolResponse = 'SolutionID' + '=' + nestedSol.Name + '\n' + 'Solution Title' + '=' + nestedSol.Solution_Title__c + '\n' + 'DSID' + '=' + nestedSol.DSID__c + '\n' + 'Diagnostic Notes' + '=' + nestedSol.Diagnostic_notes__c;
                                if(nestedSol.CSS_Solution_Components__r != null){
                                    for(CSS_Solution_Component__c components : nestedSol.CSS_Solution_Components__r){
                                        NestBMSFailureID = NestBMSFailureID + '\n' + 'Failure Name' + '=' + components.Name + '\n' + 'Failure ID' + '=' + components.Component_Id__c;
                                    }
                                }
                                NestSolCompToBMS = NestSolCompToBMS + '\n' + NestSolResponse + '\n' + NestBMSFailureID;
                            }
                        }
                    }
                    SolCompToBMS = SolCompToBMS + '\n' + SolResponse + '\n' + NestSolCompToBMS + '\n' + BMSFailureID;
                }
            }
            system.debug('inside EditCause__c>>>>'+SolCompToBMS + '\n' + workJob.Name);
            String cause = (workJob.EditCause__c == null)?'':workJob.EditCause__c.replace('\n' + 'CSS Job ID' + '=' + workJob.Name, '');
            workJob.EditCause__c = cause + SolCompToBMS + '\n' + 'CSS Job ID' + '=' + workJob.Name;
            update workJob;
        }
    }
}