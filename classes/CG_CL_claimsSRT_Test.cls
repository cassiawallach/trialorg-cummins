@istest
public class CG_CL_claimsSRT_Test {
static testmethod void testmethod1()
{
    CG_CL_claimsSRT clamsrt = new CG_CL_claimsSRT();
    clamsrt.save();
  
}
    static testmethod void testmethod2()
{
    CG_CL_ClaimsIntake cl = new CG_CL_ClaimsIntake();
    
    CSS_Claims__c claim = new CSS_Claims__c();
    
    claim.Customer_Name__c='Gopal';
    claim.Customer_Code__c='123';
    claim.Status__c='Draft';
    claim.Actual_Technician_Time__c=1.2;
    insert claim;
    cl.claimsRec=claim;
    ///apex/CG_ClaimsSRTs
    
    apexpages.currentPage().getparameters().put('id',claim.Id);
    CG_CL_claimsSRT clamsrt = new CG_CL_claimsSRT();
    clamsrt.pageRef='/apex/CG_ClaimsSRTs';
    clamsrt.mainContr=cl;
    clamsrt.save();
  
}
}