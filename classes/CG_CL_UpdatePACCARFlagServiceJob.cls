/**********************************************************************
    Name:CG_CL_UpdatePACCARFlagServiceJob
    Copyright Â© 2019  Cummins
    ======================================================
    ======================================================
    Purpose:                                                            
    -------  
    To update PACCAR Flag and PACCAR Auth Required flag in Service Job
    ======================================================
    ======================================================
    History                                                            
    -------                                                            
    VERSION       AUTHOR             DATE                DETAIL                                 
    1.0      Rajkumar/Vignesh      02/03/2019      INITIAL DEVELOPMENT                    
    ***********************************************************************/
public class CG_CL_UpdatePACCARFlagServiceJob {
    
    public CG_CL_UpdatePACCARFlagServiceJob() {

    }
    public static List<CSS_Job_Order__c> serJob = new List<CSS_Job_Order__c>();
    //Invocable method to set PACCAR flag and update PACCAR Auth required flag in service job
    @InvocableMethod(label='updatePACCARFlagServiceJob' description='to set PACCAR flag and PACCAR Auth required flag in service job') 
    public static void updatePACCARFlag(List<String> jobId){
        Id serJobId;
        CSS_Job_Order__c serJobUpd = new CSS_Job_Order__c();
        if(jobId.size() > 0)
            serJobId = jobId[0].trim();
        system.debug('Job ID -->'+serJobId);
        serJobUpd.Id = serJobId;
        CG_PACCAR_Flag_SP_Info_Mapping__c paccarCustomSettingValues;
        serJob = [SELECT Id, Account__c, Account__r.Type, SP_PACCAR__c, Territory_Class__c, CSS_Channel_Code__c, PACCAR_Auth_Required__c, PACCAR_Flag__c, Failure_Date__c, Service_Model__c, PSN_PACCAR_Flag__c FROM CSS_Job_Order__c WHERE Id =: serJobId];
        if(serJob != null && serJob.size() > 0 && serJob[0].Account__r.Type == 'Dealer Account'){
            if(serJob[0].SP_PACCAR__c == 'N'){
                String temp = serJob[0].Territory_Class__c +'-'+ serJob[0].CSS_Channel_Code__c;
                if(temp != null && temp != '')
                    paccarCustomSettingValues = CG_PACCAR_Flag_SP_Info_Mapping__c.getValues(temp);
                if(paccarCustomSettingValues == null)
                    serJobUpd.PACCAR_Auth_Required__c = false;
                else{
                    //if(serJob[0].PSN_PACCAR_Flag__c == 'N')
                    if(serJob[0].PSN_PACCAR_Flag__c == 'N' || serJob[0].PSN_PACCAR_Flag__c == null || String.isBlank(serJob[0].PSN_PACCAR_Flag__c))//Changed Condition as part of GSSC-278 to make paccar required true only when there is a value and not blank or null.
                        serJobUpd.PACCAR_Auth_Required__c = false;
                    else{
                        serJobUpd.PACCAR_Flag__c = true;
                        if(!setPACCAR_Flag()){
                            serJobUpd.PACCAR_Auth_Required__c = true;
                        }
                        else
                            serJobUpd.PACCAR_Auth_Required__c = false;
                    }
                }
            }
            else
                serJobUpd.PACCAR_Auth_Required__c = false;
        }
        if(serJobUpd != null)
            update serJobUpd;
    }
    public static boolean setPACCAR_Flag(){
        List<CSS_Accreditation__c> accredLst = new List<CSS_Accreditation__c>();
        //accredLst = [SELECT Id FROM CSS_Accreditation__c WHERE OEM_Code__c IN ('68','232','326','327') AND StartDate__c <: serJob[0].Failure_Date__c AND EndDate__c >=: serJob[0].Failure_Date__c  AND  Service_Model_Name__c =: serJob[0].Service_Model__c AND Account__c =: serJob[0].Account__c];
        //Commented above to check atleast one SMN is active for given SP code
        accredLst = [SELECT Id FROM CSS_Accreditation__c WHERE OEM_Code__c IN ('68','232','326','327') AND StartDate__c <: serJob[0].Failure_Date__c AND EndDate__c >=: serJob[0].Failure_Date__c AND Account__c =: serJob[0].Account__c];
        if(accredLst != null && accredLst.size() > 0)
            return true;
        else
            return false;
    }
}