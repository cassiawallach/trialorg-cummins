public class FSl_MaintaincePlanCont {

    @AuraEnabled
    public static string getBranchCode(string mPID){
        system.debug(mPID);
        string branchCode = '';
        try{
        MaintenancePlan mp = [select id, Service_Territory__r.Location_Code__c from MaintenancePlan where id =:mPID];
        if(string.isnotblank(mp.Service_Territory__c))
            if(mp.Service_Territory__r.Location_Code__c!=null && ((mp.Service_Territory__r.Location_Code__c).length() > 13)){
                String ukBranchCode = ((mp.Service_Territory__r.Location_Code__c.left(15)).right(9)).replace('-','');
                if(ukBranchCode.isNumeric()){
                    branchCode = ukBranchCode;
                }
            } else{
                if(((mp.Service_Territory__r.Location_Code__c.left(11)).right(5)).isNumeric()){
                    branchCode = (mp.Service_Territory__r.Location_Code__c.left(11)).right(5);
                }
            }
            
        }
        Catch(exception e){
            
        }
        return branchCode;
    }
}