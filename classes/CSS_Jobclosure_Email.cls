/*----------------------------------------------------------------------------------------
Name:CSS_Jobclosure_Email
Purpose: 70322: To Fetch the Job details & Diagnose Comments & Repair Comments & Parts/Components
Author: Sai Krishna 10/11/2016; V1
------------------------------------------------------------------------------------------*/
public class CSS_Jobclosure_Email{
    public Id sJobId {get;set;}  //'a052C000000J30S'
    public List <CSS_Solutions__c> lSol;
    public List<CSS_Solution_Component__c> sPC;   
    public List<CSS_Solutions__c> getSolutions(){    
        lSol = [select Name,Diagnostic_notes__c,Repair_Notes__c from CSS_Solutions__c where Service_Job__c =: sJobId AND Diagnostic_Response__c!= '' ORDER BY Rank__c ASC];  
        if(lSol.size()>0)
            return lSol;
        else
            return null;
    } 
    public List<CSS_Solution_Component__c> getPartsComp(){            
        sPC = [select Name,Quantity__c,Action__c from CSS_Solution_Component__c where Service_Job__c =: sJobId AND Quantity__c > 0];
        if(sPC.size()>0)            
            return sPC;
        else
            return null;
    }    
}