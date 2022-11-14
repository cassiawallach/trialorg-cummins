/**********************************************************************
Name: FSLFaultCodeBatchProcess
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is a monthly batch job scheduled for 'Get Fault Code' integrations to populate values for Fault Code, SPN-FMI and DTC code dropdown
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         2/19/2019                         
***********************************************************************/

global class FSLFaultCodeBatchProcess implements Database.batchable<FSLFaultCodeWrapper>,Database.AllowsCallouts,Database.Stateful
{ 
    global String tokenStr ;
    global String query;
    /*STARTS -- START METHOD*/  
    global Iterable<FSLFaultCodeWrapper> start(Database.BatchableContext BC)    
    { 
        system.debug('*****************START METHOD**********************');
        return new FSLFaultCodeRespIterable();
    }
    /*ENDS -- START METHOD*/
    /*STARTS -- EXECUTE METHOD*/
    global void execute(Database.BatchableContext info, List<FSLFaultCodeWrapper> scope)        
    {       
        // upsert Fault Types based Response and getting the responses from wrapper class 
        /* FSL_Fault_Code__c objfaultcode;
        FSL_SPN_FMI__c objspnfmi;
        FSL_PCode__c objpcode; */
        List <FSL_Fault_Code__c> cfcList = new List <FSL_Fault_Code__c> ();
        List <FSL_SPN_FMI__c> spmfmiList = new List <FSL_SPN_FMI__c> ();
        List <FSL_PCode__c> pcodeList = new List <FSL_PCode__c> ();
        
        for(FSLFaultCodeWrapper fsr : scope)
        {
            system.debug('Test'+fsr.Cummins_Fault_Code);  
            if(String.isNotBlank(fsr.Id) && String.isNotBlank(fsr.Cummins_Fault_Code)) {
                FSL_Fault_Code__c objfaultcode = new FSL_Fault_Code__c();
                objfaultcode.Name = fsr.Cummins_Fault_Code;
                objfaultCode.CDS_ID__c = fsr.Id;
                objfaultCode.Algorithm_Description__c = fsr.Algorithm_Description;
                objfaultCode.Cummins_Description__c = fsr.Cummins_Description;
                objfaultCode.Cummins_Fault_Code__c = fsr.Cummins_Fault_Code;
                objfaultCode.Information__c = fsr.Information; 
                objfaultCode.J1939_FMI__c = fsr.J1939FMI;
                objfaultCode.J2012_PCode__c = fsr.J2012_Pcode;
                objfaultCode.Lamp_Color__c = fsr.Lamp_Color;
                objfaultCode.Lamp_Device__c = fsr.Lamp_Device;
                objfaultCode.LanguageKey__c = fsr.LanguageKey;
                if(String.isNotBlank(fsr.Published_in_CES_14602)){
                objfaultCode.Published_in_CES_14602__c = Boolean.valueOf(fsr.Published_in_CES_14602);
                }
                objfaultCode.Revision__c = fsr.Revision;
                objfaultCode.Special_Instructions__c = fsr.Special_Instructions;
                objfaultCode.SPN__c = fsr.SPN;
                cfcList.add(objfaultcode);
            }
            if(String.isNotBlank(fsr.Id) && String.isNotBlank(fsr.SPN) && String.isNotBlank(fsr.J1939FMI)) {
            FSL_SPN_FMI__c objspnfmi = new FSL_SPN_FMI__c (); 
                objspnfmi.Name = fsr.SPN+'-'+fsr.J1939FMI;
                objspnfmi.CDS_ID__c = fsr.Id;
                objspnfmi.Algorithm_Description__c = fsr.Algorithm_Description;
                objspnfmi.Cummins_Description__c = fsr.Cummins_Description;
                objspnfmi.Cummins_Fault_Code__c = fsr.Cummins_Fault_Code;
                objspnfmi.Information__c = fsr.Information; 
                objspnfmi.J1939_FMI__c = fsr.J1939FMI;
                objspnfmi.J2012_PCode__c = fsr.J2012_Pcode;
                objspnfmi.Lamp_Color__c = fsr.Lamp_Color;
                objspnfmi.Lamp_Device__c = fsr.Lamp_Device;
                objspnfmi.LanguageKey__c = fsr.LanguageKey;
                if(String.isNotBlank(fsr.Published_in_CES_14602)){
                 objspnfmi.Published_in_CES_14602__c = Boolean.valueOf(fsr.Published_in_CES_14602);
                }
                objspnfmi.Revision__c = fsr.Revision;
                objspnfmi.Special_Instructions__c = fsr.Special_Instructions;
                objspnfmi.SPN__c = fsr.SPN;
                spmfmiList.add(objspnfmi);
            }
            if(String.isNotBlank(fsr.Id) && String.isNotBlank(fsr.J2012_Pcode)) {
                  FSL_PCode__c objpcode = new FSL_PCode__c(); 
                objpcode.Name = fsr.J2012_Pcode;
                objpcode.CDS_ID__c = fsr.Id;
                objpcode.Algorithm_Description__c = fsr.Algorithm_Description;
                objpcode.Cummins_Description__c = fsr.Cummins_Description;
                objpcode.Cummins_Fault_Code__c = fsr.Cummins_Fault_Code;
                objpcode.Information__c = fsr.Information; 
                objpcode.J1939_FMI__c = fsr.J1939FMI;
                objpcode.J2012_PCode__c = fsr.J2012_Pcode;
                objpcode.Lamp_Color__c = fsr.Lamp_Color;
                objpcode.Lamp_Device__c = fsr.Lamp_Device;
                objpcode.LanguageKey__c = fsr.LanguageKey;
                if(String.isNotBlank(fsr.Published_in_CES_14602)){
                objpcode.Published_in_CES_14602__c = Boolean.valueOf(fsr.Published_in_CES_14602);
                }
                objpcode.Revision__c = fsr.Revision;
                objpcode.Special_Instructions__c = fsr.Special_Instructions;
                objpcode.SPN__c = fsr.SPN;
                pcodeList.add(objpcode);
            }
        }
        if(cfcList.size() > 0) {
          //  upsert cfcList;
            Database.upsert(cfcList, false);
        }
        if(spmfmiList.size() > 0) {
           // upsert spmfmiList;
            Database.upsert(spmfmiList, false);
        }
        if(pcodeList.size() > 0) {
            //upsert pcodeList;
            Database.upsert(pcodeList, false);
        }
    }
   
    global void finish(Database.BatchableContext info){
        system.debug('*****************FINISH METHOD**********************');
    }    
}