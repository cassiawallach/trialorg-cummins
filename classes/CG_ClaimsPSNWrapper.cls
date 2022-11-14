/*
 * Block comments with details of changes
 */
public class CG_ClaimsPSNWrapper
{
    public CSS_PSN__c psnNewRec{set;get;}

    // public CG_ClaimsHeaderWrapper(css_Claims__c claimsRec,String filterMake,String filterModel,String mil_measure,String fail_measure,String filterCountry,String filterState,Boolean bmsEnabled,String EmailAddress,String EmailAddress1,boolean emailCheckbox){
    public CG_ClaimsPSNWrapper(CSS_PSN__c psnRec){
        psnNewRec = new CSS_PSN__c();
        psnNewRec.Unit_Number__c = psnRec.Unit_Number__c;
        psnNewRec.Application__c = psnRec.Application__c;
        psnNewRec.Before_In_Service__c = psnRec.Before_In_Service__c;
        psnNewRec.Calibration_After__c = psnRec.Calibration_After__c;
        psnNewRec.Calibration_Before__c = psnRec.Calibration_Before__c;
        psnNewRec.CSS_Claims__c = psnRec.CSS_Claims__c;
        psnNewRec.Failure_Date__c = psnRec.Failure_Date__c;
        psnNewRec.Justification__c = psnRec.Justification__c;
        psnNewRec.License_Plate_State__c = psnRec.License_Plate_State__c;
        psnNewRec.Mission_Disabling__c = psnRec.Mission_Disabling__c;
        psnNewRec.Model__c = psnRec.Model__c;
        psnNewRec.Primary__c = psnRec.Primary__c;
        psnNewRec.Product_Hours__c = psnRec.Product_Hours__c;
        psnNewRec.Qsol_Engine_Family_Code__c = psnRec.Qsol_Engine_Family_Code__c;
        psnNewRec.Qsol_Technical_Config__c = psnRec.Qsol_Technical_Config__c;
        psnNewRec.Qsol_Warranty_Start__c = psnRec.Qsol_Warranty_Start__c;
        psnNewRec.Service_Model__c = psnRec.Service_Model__c;
        psnNewRec.Unit_Type__c = psnRec.Unit_Type__c;
        psnNewRec.VIN__c = psnRec.VIN__c;
        psnNewRec.Warranty_Start_Date__c = psnRec.Warranty_Start_Date__c;



    }
}