/**********************************************************************
Name:FSL_Update_Correction
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
1.0 - vinod           11/30/2016          INITIAL DEVELOPMENT
***********************************************************************/

public class FSL_Update_Correction {
    @InvocableMethod(label='FSLupdateCorrection' description='updateCorrection from Process Builder')
    public static void FSLupdateCorrection(List<Id> solId){
        
        List<CSS_Solutions__c> lstSolutions;
        //Added by vinod yellala for repair
        List<WorkOrder> fslWOs=new List<WorkOrder>();
        WorkOrder fslWO;
        system.debug('solId: '+solId);
        lstSolutions = [Select Id, Name,Solution_Title__c, Rank__c,DSID__c,FSL_Service_Job__c,//(select id,FailurepartId__c from CSS_Parts_Options__r),
                        Diagnostic_notes__c, Diagnostic_Response__c,Repair_Response__c,Repair_Notes__c, FaultCode__c,FaultCode__r.name,
                        (select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c 
                         from CSS_Solution_Components__r where Selected_Component__c=TRUE)
                        from CSS_Solutions__c where Id = :solId];//removed check and CSS_Nested_Solutions__c = null from 9/6 - by vinod
        if(!lstSolutions.isEmpty() && lstSolutions.size()>0)
        {
            //workJob=[Select Id,Name,EditCorrection__c from CSS_Job_Order__c where id= :lstSolutions[0].Service_Job__c];
            //Starts added by vinod 7/3 for 4C's on FSL
            fslWOs=[Select Id,WorkOrderNumber,EditCorrection__c,Correction_Notes__c from Workorder where id= :lstSolutions[0].FSL_Service_Job__c];//added by vinod 6/3 for 4C's on FSL
            if(fslWOs.size()>0)
            {
                fslWO=fslWOs[0];
                if(String.isBlank(fslWO.EditCorrection__c))
                    fslWO.EditCorrection__c='';
                //Ends added by vinod 7/3 for 4C's on FSL
                String SolCompToBMS='';
                String RepResponse='';
                String BMSFailureID='';
                String BMSFailureID2='';
                BMSFailureID='';
                for(CSS_Solutions__c solutions : lstSolutions){
                    if(fslWO != null)
                    {
                        if(solutions.Repair_Response__c != null && (solutions.Repair_Response__c.equalsIgnoreCase('Repair Successful.') || 
                                                                    solutions.Repair_Response__c.equalsIgnoreCase('Repair Successful with additional parts/procedures.'))){
                            if(String.isBlank(solutions.FaultCode__r.name))
                                RepResponse = 'Solution Title'+':' + solutions.Solution_Title__c+'\nRepair Notes'+':'+solutions.Repair_Notes__c + '\n';
                            else
                                RepResponse = solutions.FaultCode__r.name +'\nSolution Title'+':' + solutions.Solution_Title__c+'\nRepair Notes'+':'+ solutions.Repair_Notes__c + '\n';
                            system.debug('RepResponse>>>>*****'+RepResponse);
                            if(!solutions.CSS_Solution_Components__r.isempty()){
                                system.debug('solutions.CSS_Solution_Components__r>>>>*****'+solutions.CSS_Solution_Components__r); 
                                for(CSS_Solution_Component__c components : solutions.CSS_Solution_Components__r){
                                    //for(CSS_Parts_Options__c p:components.CSS_Parts_Options__r){
                                    if(components.Component_Id__c!=null && components.Selected_Component__c == true){
                                        system.debug('components.Component_Id__c 2 '+components.Component_Id__c);
                                        BMSFailureID = BMSFailureID + 'Root Cause' + ':' + components.Name+'\n';// + '\n' + components.Quantity__c; 
                                        //if(components.Id == p.FailurepartId__c)
                                        //{
                                        //BMSFailureID =BMSFailureID + (components.Quantity__c != null && components.Quantity__c != 0 ? '\n' +'Quantity' + '=' + components.Quantity__c : '');
                                        //}
                                    }
                                    
                                }
                            }                        
                            system.debug('BMSFailureID>>>> '+BMSFailureID);
                            SolCompToBMS = SolCompToBMS + '\n' + RepResponse +  BMSFailureID;
                            system.debug('After SolCompToBMS*****************'+SolCompToBMS);
                        }
                    }
                    system.debug('for...........'); 
                }
                String partStr;
                for(FSL_Parts__c fp : [select part_Quantity__c, Part_Name__c from FSL_Parts__c where Select__c=true and Service_Order__c= :fslwo.id
                                      and Solution__r.Repair_Response__c IN ('Repair Successful.', 'Repair Successful with additional parts/procedures.')])
                {
                    if(String.isBlank(partStr))
                        partStr = '\nParts:';
                    partStr += '\nQuantity ('+fp.Part_Quantity__c+') ' + fp.Part_Name__c;
                }
                // Added By vinod for the Custom Parts
                String cuspartStr;
                for(FSL_Custom_Part__c fp : [select Quantity__c, Name from FSL_Custom_Part__c where  Service_Order__c= :fslwo.id])
                {
                    if(String.isBlank(partStr))
                        partStr = '\nParts:';
                    partStr += '\nQuantity ('+fp.Quantity__c+') ' + fp.name;
                }
                //system.debug('inside Correction>>>>'+SolCompToBMS + '\n' + workJob.Name);
                
                //  
                String correction;
                String correctionToAppend;
                if(fslWO != null)
                {
                    correction = (fslWO.EditCorrection__c == null)?'':fslWO.EditCorrection__c.replace('\n' + 'CSS Job ID' + '=' + fslWO.WorkOrderNumber, '');//added by vinod 6/3 for 4C's on FSL
                    fslWO.EditCorrection__c += /*correction + */SolCompToBMS +'\n';//added by vinod 7/3 for 4C's on FSL
                   if(String.isBlank(partStr))
                       fslwo.Selected_Parts__c = '';
                   else
                       fslwo.Selected_Parts__c = partStr;
                  correctionToAppend = (fslWO.Correction_Notes__c == null)?'':fslWO.Correction_Notes__c;
                   fslWo.Correction_Notes__c = correctionToAppend + fslWO.EditCorrection__c + '\n' + fslwo.Selected_Parts__c; // added by sailaja , CT3-435 bug- to append manually added notes
                   fslWo.EditCorrection__c = '';
                   system.debug('fslWO.EditCorrection__c>>'+fslWO.EditCorrection__c);
                    update fslWO;//added by vinod 7/3 for 4C's on FSL
                }
            }
        }
    }
    
}