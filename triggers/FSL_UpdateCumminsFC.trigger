trigger FSL_UpdateCumminsFC on CSS_Fault_Code__c (before Insert,before update) {
    //Added by Murali to fix recursion on Fault_code__c which is causing the build failures
    if(Trigger.isBefore && FSL_UpdateCumminsFCHandler.isCSSFaultCode == False) {
      FSL_UpdateCumminsFCHandler.isCSSFaultCode = true;
      FSL_UpdateCumminsFCHandler.populateCumminscode(Trigger.new);
    }
}