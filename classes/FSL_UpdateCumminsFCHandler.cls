public class FSL_UpdateCumminsFCHandler {
    Public static Boolean isCSSFaultCode=false; //Added by Murali to fix recursion on Fault_code__c which is causing the build failures
    public static void populateCumminscode(List<CSS_Fault_Code__c> cssFaultCodes){
        
        system.debug('Testfaultcodes'+cssFaultCodes);
        Map<Id,String> cssIdNameMap = new Map<Id,String>();
        Map<Id,Set<Id>> serviceorderCssIdMap = new Map<Id,Set<Id>>();
        Map<Id,String> cssIdServiceModelMap = new Map<Id,String>();
        Map<String,Id> cssNameFaultcodeIdMap = new Map<String,Id>();
        Map<Id,Id> serviceorderCssIdMap1 = new Map<Id,Id>();
        Set<Id> cssIds = new Set<Id>();
        
        for(CSS_Fault_Code__c css:cssFaultCodes){
            cssIdNameMap.put(css.Id,css.Name);
            if(serviceorderCssIdMap.containsKey(css.Service_Order__c)){
                cssIds.add(css.Id);
                serviceorderCssIdMap.put(css.Service_Order__c,cssIds);
            }
            else{
                cssIds.add(css.Id);
                serviceorderCssIdMap.put(css.Service_Order__c,cssIds);
            }
            serviceorderCssIdMap1.put(css.Id,css.Service_Order__c);
            
        }
        System.debug('cssFaultCodesMap '+cssIdNameMap);
            List<WorkOrder> serModelList = [SELECT Id,Service_Model__c  FROM WorkOrder where Id =:serviceorderCssIdMap1.values()];
            for(WorkOrder woRec:serModelList){
                Set<Id> cssId = serviceorderCssIdMap.get(woRec.Id);
                for(Id cssIDn:cssId){
                   cssIdServiceModelMap.put(cssIDn,woRec.Service_Model__c);  
                }
            }
            system.debug('WorkOrder***'+cssIdServiceModelMap);
                List<FSL_Fault_Code__c> CumminsFaultRecList = [SELECT Id,Name FROM FSL_Fault_Code__c WHERE Name=:cssIdNameMap.values() AND FSL_SMN__r.Name=:cssIdServiceModelMap.values()];
                for(FSL_Fault_Code__c fslsccode:CumminsFaultRecList){
                    cssNameFaultcodeIdMap.put(fslsccode.Name,fslsccode.Id);
                }
                system.debug('CumminsFaultRec***'+CumminsFaultRecList);
                    for(CSS_Fault_Code__c css:cssFaultCodes){
                        css.Cummins_Fault_Code__c = cssNameFaultcodeIdMap.get(css.Name);
                    }
    }
}