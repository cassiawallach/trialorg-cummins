/*
 * Block comments with details of changes
 */
public class CG_ClaimsHeaderWrapper
{
    public CSS_Claims__c claimNewRec{set;get;}
    
   // public CG_ClaimsHeaderWrapper(css_Claims__c claimsRec,String filterMake,String filterModel,String mil_measure,String fail_measure,String filterCountry,String filterState,Boolean bmsEnabled,String EmailAddress,String EmailAddress1,boolean emailCheckbox){
     public CG_ClaimsHeaderWrapper(CSS_Claims__c claimsRec){ //,String filterCountry){
         claimNewRec = new CSS_Claims__c();
        system.debug('claimsRec.Customer_Name__c**'+claimsRec.Customer_Name__c);
    claimNewRec.Customer_Name__c = claimsRec.Customer_Name__c;
            claimNewRec.Customer_Code__c = claimsRec.Customer_Code__c;
            claimNewRec.Contact_First_Name__c = claimsRec.Contact_First_Name__c;
            claimNewRec.Contact_Last_Name__c = claimsRec.Contact_Last_Name__c;
                claimNewRec.Customer_Contact_Phone__c = claimsRec.Customer_Contact_Phone__c;
            claimNewRec.Email_Address__c = claimsRec.Email_Address__c;
            claimNewRec.Address__c = claimsRec.Address__c;
            //claimNewRec.Country__c = filterCountry;
                        claimNewRec.State__c = claimsRec.State__c;
            claimNewRec.ZipCode__c = claimsRec.ZipCode__c;
            claimNewRec.Repair_Location__c = claimsRec.Repair_Location__c;
            claimNewRec.Service_Date__c = claimsRec.Service_Date__c;
                claimNewRec.Repair_Completion__c = claimsRec.Repair_Completion__c;
            
        
    }
}