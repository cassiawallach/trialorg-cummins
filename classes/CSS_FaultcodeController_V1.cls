/**********************************************************************
Name: CSS_FaultcodeController_V1
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Component Controller that displays timestamp, solutions from eds.                                                              
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Varun Sinha        1/25/2016             INITIAL DEVELOPMENT                         
2.0 - Anirudh            2/11/2016             Coding Standards
***********************************************************************/

public class CSS_FaultcodeController_V1 {
    List<CSS_Fault_Code__c> faultCodes;
    List<CSS_Solutions__c> solutions;
    datetime dsidtimestamp;
    datetime insitetimestamp;
    public ID JobID ;
    public Boolean isPrioritized {get; set;}
    public ID getJobID(){ return JobID; }
    public void setJobID(ID j){
        JobID = j;
        System.debug('The job id is>>>>'+JobID);
        List<CSS_Fault_Code__c> fcCodes= getfaultCodes();
    }
    public List<CSS_Fault_Code__c> getfaultCodes() {
        AggregateResult[]  fc = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:JobID];
        if(fc.size()>0){
            integer maxSeq = integer.valueOf(fc[0].get('maxSeq'));
            faultCodes = [select Primary_Fault_Code__c, FaultCode__c, Fault_Code_Type__c, Related_Fault_Code__c from CSS_Fault_Code__c 
                          where Job_Order__c=:JobID and Sequence__c=:maxSeq and Fault_Code__c !=Null];
            for ( CSS_Fault_Code__c prCodes: faultCodes) {
                if (prCodes.Fault_Code_Type__c.startsWith('APD')) {
                    isPrioritized = true;
                } else if (prCodes.Fault_Code_Type__c.startsWith('BPD')){
                    isPrioritized = true;
                }
                else {
                    isPrioritized = false;
                }
            }
        }
        return faultCodes;
    }
    
    public List<CSS_Solutions__c> getsolutions() {
        solutions = [select Case_Name__c,Solution_Title__c,Name from CSS_Solutions__c where Service_Job__c=:JobID and Case_Name__c!=Null and (Not Name like 'a0%') limit 5];
        System.debug('The solution is>>>>>>>>>'+solutions);
        return solutions;      
    }
    public datetime getInsiteTimeStamp(){
        insitetimestamp = [select INSITE_UpdateTimeStamp__c from  CSS_Job_Order__c where id=:JobID].INSITE_UpdateTimeStamp__c;
        return insitetimestamp;
    }
    public string getInsiteTimeStr(){
        string insitetime;
        insitetimestamp = [select INSITE_UpdateTimeStamp__c from  CSS_Job_Order__c where id=:JobID].INSITE_UpdateTimeStamp__c;
        if (insitetimestamp !=null) {
            insitetime=string.valueof(insitetimestamp.format('dd MMM yyyy - hh:mm a z'));
        }
        return insitetime;
    }
    public AggregateResult getRepair(){
        AggregateResult repair;
        repair = [Select count(Case_Name__c) from CSS_Solutions__c where Service_Job__c=:JobID and Case_Name__c!=Null and (Not Name like 'a0%')];
        System.debug('The solutions is!!!!!!!!>>>>>>>>'+repair);
        return repair;
    }
    public datetime getDSIDTimeStamp(){
        string dsidstamp;
        dsidtimestamp = [select DSID_UpdateTimestamp__c from  CSS_Job_Order__c where id=:JobID ].DSID_UpdateTimestamp__c;
        return dsidtimestamp;
    }
    public string getDSIDStamp(){
        string dsidstamp;
        dsidtimestamp = [select DSID_UpdateTimestamp__c from  CSS_Job_Order__c where id=:JobID ].DSID_UpdateTimestamp__c;
        if(dsidtimestamp!=null){
            dsidstamp=string.valueof(dsidtimestamp.format('dd MMM yyyy - hh:mm a z'));
        }
        return dsidstamp;
    }   
}