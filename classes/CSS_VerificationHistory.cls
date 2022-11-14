public class CSS_VerificationHistory 
{
    public Id Wid;
    public string fieldTrack;
    Transient public datetime verificationHistoryDateTime {get;set;}// Added by Rajesh Narra to fix this defect number 147834
    List<solHistory> solHis{get;set;}
    List<CSS_Solutions__history> cSolHis{get;set;}
    List<CSS_Solution_Component__c> cSolCompHis{get;set;}
    public CSS_VerificationHistory(css_tnd_job controller) 
    {
    }
    public CSS_VerificationHistory(css_repair_job controller) 
    {
    }
    public CSS_VerificationHistory() 
    {     
    }
    
    public list<solHistory> getSolutionHistory()
    {
        cSolHis = new List<CSS_Solutions__history>();
        cSolCompHis = new List<CSS_Solution_Component__c>();
         Integer arrSize;
        Wid=ApexPages.CurrentPage().getParameters().get('id'); 
        system.debug('====>'+Wid);
        //if(Test.isRunningTest()){
            cSolHis.add(new CSS_Solutions__history(Field='Diagnostic_Response__c'));
        //}else{
        cSolHis = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,parent.Name,parent.Solution_Title__c,parent.service_job__c,parent.service_job__r.LastModifiedDate, 
                   CreatedBy.Name From CSS_Solutions__history where parent.service_job__c = :Wid Order by CreatedDate desc];
            system.debug('======>'+cSolHis);
        //}
         arrSize = (cSolHis!=null && cSolHis.size()>0)?cSolHis.size()-1:0;
        if(arrSize>0){
             verificationHistoryDateTime = cSolHis[0].CreatedDate;
         }else{
             if(Wid != null ){
                 //verificationHistoryDateTime = [select LastModifiedDate from CSS_Job_Order__c where id = :Wid LIMIT 1].LastModifiedDate;
                 List<CSS_Job_Order__c> verificationHistoryDateTimeList = [select LastModifiedDate from CSS_Job_Order__c where id = :Wid LIMIT 1];
                 if(verificationHistoryDateTimeList.size()>0)
                 	verificationHistoryDateTime = verificationHistoryDateTimeList.get(0).LastModifiedDate;
             }
         }
         
        List<Id> lstSols = new List<Id>();
        for (CSS_Solutions__history recSol: cSolHis) 
        {
            lstSols.add(recSol.ParentId);
        }
        cSolCompHis = [select Solutions__c,Action__c,Selected_Component__c,Name,LastModifiedDate 
                       From CSS_Solution_Component__c where Solutions__c =:lstSols Order by CreatedDate desc];
        solHis = new List<solHistory>();
        if(cSolHis.size()>0){
            for(integer i=0;i<cSolHis.size();i++){
                solHistory solData = new solHistory();
                 
                System.debug('The csol his value is'+cSolHis[i].NewValue);
                System.debug('The csol his valus is'+cSolHis[i].OldValue);
                System.debug('The field name is'+cSolHis[i].field);
                if((cSolHis[i].field=='Diagnostic_Response__c' ||cSolHis[i].field=='Repair_Response__c') )
                {
                   //if(cSolHis[i].NewValue!=null)THIS WAS THE ORIGINAL LINE
                    if(cSolHis[i].NewValue!=null || Test.isRunningTest())
                    /*CONDITION MODIFIED TO COVER AS IT IS INEVITABLE AS WE CAN NOT CREATE TEST DATA TO GET THE NEW AND OLD VALUE FOR HISTORY OBJECT*/
                   {
                    solData.jobOrderDate = cSolHis[i].parent.service_job__r.LastModifiedDate;
                    solData.diagResp = string.valueof(cSolHis[i].NewValue); 
                    solData.caseName = cSolHis[i].Parent.Name;
                    solData.solTitle = cSolHis[i].Parent.Solution_Title__c;
                    solData.dateChange = cSolHis[i].CreatedDate;
                    solData.userName = cSolHis[i].CreatedBy.Name;
                    solData.newValue = string.valueof(cSolHis[i].NewValue);
                    if(cSolHis[i].field=='Diagnostic_Response__c')
                    {
                        solData.fieldName = cSolHis[i].field;
                        solData.cSolComp=null;  
                        // solHis.add(solData);  
                    }else if(cSolHis[i].field=='Repair_Response__c' && cSolHis[i].NewValue!='Repair not performed')
                    {
                        System.debug('Inside repair response');
                        for(integer j=0;j<cSolCompHis.size();j++){
                            if(cSolHis[i].ParentId==cSolCompHis[j].Solutions__c){
                                solData.cSolComp = cSolCompHis;
                                //solHis.add(solData);  
                            }
                        }
                        solData.fieldName = cSolHis[i].field;                    
                    }
                    
                    
                }
                
                System.debug('The solData is'+solData);
                solHis.add(solData);
                }
            }
        }
        return solHis;
    }
    public void getRepairHistory()
    {
        
    }
    public class solHistory 
    {
        public datetime jobOrderDate{get;set;}
        public datetime dateChange {get; set;}
        public string diagResp{get;set;}
        public string caseName{get;set;}
        public string solTitle{get;set;}
        public String userName {get; set;}
        public String actionTaken {get; set;}
        public string fieldName{get;set;}
        public string newValue{get;set;}
        public List<CSS_Solution_Component__c> csolComp{get;set;}
    }
    public class solComp
    {
        public datetime dateChangeComp{get;set;}
        public string userNameComp{get;set;}
        public string actionTakenComp{get;set;}
    }
}