/**********************************************************************
Name:CSS_FN_EditCorrection
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
1.0 - Anirudh           11/30/2016          INITIAL DEVELOPMENT
***********************************************************************/

public class CSS_FN_EditCorrection {
     @InvocableMethod(label='updateCorrection' description='updateCorrection from Process Builder')
    public static void updateCorrection(List<Id> solId){
        CSS_Job_Order__c workJob;
        List<CSS_Solutions__c> lstSolutions;
        system.debug('solId: '+solId);
        lstSolutions = [Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c,//(select id,FailurepartId__c from CSS_Parts_Options__r),
                        Diagnostic_notes__c, Diagnostic_Response__c,Repair_Response__c,Repair_Notes__c, FaultCode__c,(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c from CSS_Solution_Components__r)
                        from CSS_Solutions__c where Id = :solId and CSS_Nested_Solutions__c = null];
        if(!lstSolutions.isEmpty() && lstSolutions.size()>0){
        workJob=[Select Id,Name,EditCorrection__c from CSS_Job_Order__c where id= :lstSolutions[0].Service_Job__c];
        
             String SolCompToBMS='';
             String RepResponse='';
             String BMSFailureID='';
             String BMSFailureID2='';       
            
            BMSFailureID='';
        for(CSS_Solutions__c solutions : lstSolutions){
            
            if(solutions.Repair_Response__c != null && (solutions.Repair_Response__c.equalsIgnoreCase('Repair Successful.') || solutions.Repair_Response__c.equalsIgnoreCase('Repair Successful with additional parts/procedures.'))){
                RepResponse = 'Repair Notes' + '=' + solutions.Repair_Notes__c + '\n' + 'SolutionID' + '=' + solutions.Name + '\n' + 'Solution Title' + '=' + solutions.Solution_Title__c;
                system.debug('RepResponse>>>>*****'+RepResponse);
                if(!solutions.CSS_Solution_Components__r.isempty()){
                    system.debug('solutions.CSS_Solution_Components__r>>>>*****'+solutions.CSS_Solution_Components__r); 
                    for(CSS_Solution_Component__c components : solutions.CSS_Solution_Components__r){
                        //for(CSS_Parts_Options__c p:components.CSS_Parts_Options__r){


                            if(components.Component_Id__c==''){
                                system.debug('components.Component_Id__c 1 '+components.Component_Id__c);
                            }else if(components.Component_Id__c!=null && components.Selected_Component__c == true){
                                system.debug('components.Component_Id__c 2 '+components.Component_Id__c);
                                BMSFailureID = BMSFailureID + '\n' + 'Failure Name' + '=' + components.Name;// + '\n' + components.Quantity__c; 
                                //if(components.Id == p.FailurepartId__c)
                                //{
                                    BMSFailureID =BMSFailureID + (components.Quantity__c != null && components.Quantity__c != 0 ? '\n' +'Quantity' + '=' + components.Quantity__c : '');
                                //}
                            }
                       // }
                    }
                }
           /* if(BMSFailureID==null)
                   BMSFailureID=''; */
                system.debug('BMSFailureID>>>> '+BMSFailureID);
                SolCompToBMS = SolCompToBMS + '\n' + RepResponse +  BMSFailureID;
                system.debug('After SolCompToBMS*****************'+SolCompToBMS);
            }
            system.debug('for...........'); 
        }
        system.debug('inside Correction>>>>'+SolCompToBMS + '\n' + workJob.Name);
            
            system.debug('inside Correction>>>>'+SolCompToBMS + '\n' + workJob.Name);
            String correction = (workJob.EditCorrection__c == null)?'':workJob.EditCorrection__c.replace('\n' + 'CSS Job ID' + '=' + workJob.Name, '');
            workJob.EditCorrection__c = correction + SolCompToBMS + '\n' + 'CSS Job ID' + '=' + workJob.Name;
            update workJob;
        }
    }

}