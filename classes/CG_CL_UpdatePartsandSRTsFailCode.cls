/*
 * Block comments with details of changes
 */

public class CG_CL_UpdatePartsandSRTsFailCode {

public class MyInvocableVariable {
    @InvocableVariable(label='Id' required=true)
    public Id recId;

    @InvocableVariable(label='Old Value' required=true)
    public String oldVal;

    @InvocableVariable(label='Current Value' required=true)
    public String currVal;
}

@InvocableMethod(label='UpdatePartsandSRTsFailCode' description='Update Parts and SRTs FailCode up on update of Solution component FailCode')
public static void UpdatePartsandSRTsFailCode(List<MyInvocableVariable> myInvocableVariableList) {
string oldFailCode;
    Id jobId;
    Id solCompId;
    for(MyInvocableVariable myInvocableVariable : myInvocableVariableList) {
        system.debug('recId=' + myInvocableVariable.recId + ', oldVal=' + myInvocableVariable.oldVal + ', currVal=' + myInvocableVariable.currVal);            
    oldFailCode = myInvocableVariable.oldVal;
        solCompId = myInvocableVariable.recId;
        system.debug('oldFailCode**'+oldFailCode);
        system.debug('solCompId**'+solCompId);
    }
        List<Css_job_order__c> jobList = new List<Css_job_order__c>();
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        List<Css_SRT__c> srtList = new List<Css_SRT__c>();
        List<Css_SRT__c> updatesrtList = new List<Css_SRT__c>();
        List<Css_Parts_Options__c> partList = new List<Css_Parts_Options__c>();
        List<Css_Parts_Options__c> updatepartList = new List<Css_Parts_Options__c>();
        Set<string> failcodeSet = new Set<string>();
        //jobList = [select id,service_job__c from CSS_Solution_Component__c where id IN myInvocableVariable.recId];
        jobId = [select id,service_job__c from CSS_Solution_Component__c where id = :solCompId].service_job__c;
        solCompList = [select id,fail_code__c,type__c,solutions__c,Solutions__r.Diagnostic_Response__c from CSS_Solution_Component__c where service_job__c = :jobId];
        srtList = [Select id,failcode__c from css_srt__c where job_order__c = :jobId and failcode__c = :oldFailCode];
        partList = [Select id,Fail_Code__c from css_parts_options__c where Service_Job__c  = :jobId and Fail_Code__c = :oldFailCode];
        system.debug('jobId**'+jobId);
    system.debug('solCompList**'+solCompList);
    system.debug('srtList**'+srtList);
    system.debug('partList**'+partList);
        for(CSS_Solution_Component__c solComp: solCompList){
           if(solComp.fail_code__c != null && solComp.fail_code__c != '' && solComp.Solutions__r.Diagnostic_Response__c=='Most likely the solution' && solComp.type__c!='CAMP' && solComp.type__c!='TRP' && solComp.type__c!='ATC' )
            failcodeSet.add(solComp.fail_code__c);
        
        }
    system.debug('failcodeSet**'+failcodeSet);
        if(failcodeSet != null && !failcodeSet.contains(oldFailCode)){
            for(Css_Srt__c srt: srtList){
                if(srt.failcode__c == oldFailCode)
                {srt.failcode__c = '';
                updatesrtList.add(srt);}
            }
             for(Css_Parts_Options__c part: partList){
                 if((part.fail_code__c).contains(oldFailCode)){
                part.Fail_Code__c = '';
                updatepartList.add(part);}
            }
        }
    system.debug('updatesrtList**'+updatesrtList);
    system.debug('updatepartList**'+updatepartList);
    if(updatesrtList != null && updatesrtList.size()>0)
        update updatesrtList;
    if(updatepartList != null && updatepartList.size()>0)
        update updatepartList;
    }

}