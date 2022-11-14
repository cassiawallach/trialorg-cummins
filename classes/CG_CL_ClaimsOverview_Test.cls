/*VERSION    
              AUTHOR                          DATE                  DETAIL
1.0         Rupesh Pande                    27-03-2018          Initial Development(92% Covered)
*/
@isTest
public class CG_CL_ClaimsOverview_Test 
{
  
    public static testMethod void CG_CL_ClaimsOverview_Testmethod1()
    {
        
        //Create a job
        CSS_Job_Order__c cjo=new CSS_Job_Order__c();
        insert cjo;
        
        //Create a claim with a location and a job
        CSS_Claims__c  testclaimsRec= new CSS_Claims__c();
        testclaimsRec.CSS_Job__c=cjo.id;
        insert testclaimsRec;
        list<css_claims__c> iclmlist=[select createddate,Location_Code__c,css_job__r.createddate,LastModifiedDate from CSS_Claims__c];
        
        //CreatedDate of the Test Claim
        system.debug('Claim: Created Date of the claim is: '+iclmlist[0].createddate);
        
        //Claim Created Date to String
        String cscdt = iclmlist[0].createddate.format();
        system.debug('Claim: The Claim created date in string is:'+cscdt);
        
        //Call the utility class to get the created date
        string cucdt=css_utility.getFormattedDate(testclaimsRec.CreatedDate); 
        system.debug('Claim: The Claim created date by utility:'+cscdt);
        
        //Call the utility class to get the formatted date        
        string cumdt=css_utility.getFormattedDate(testclaimsRec.LastModifiedDate); 
        system.debug('Claim: The Claim modified date by utility:'+cscdt);
        
        //Instantiate the controller class
        CG_CL_ClaimsOverview cow=new CG_CL_ClaimsOverview(); 
        CG_CL_ClaimsIntake clintk = new CG_CL_ClaimsIntake(); 
        cow.mainContr=clintk;//Main Controller Refrence
        
        //GET and SET the claim 
        cow.claimsRec=iclmlist[0];
        cow.createdDT=cscdt; 
        cow.modifyDT=cumdt;
        testclaimsRec.Location_Code__c='03742';
        update testclaimsRec;
        iclmlist=[select createddate,Location_Code__c,css_job__r.createddate,LastModifiedDate from CSS_Claims__c];
        cow.claimsRec=iclmlist[0];
        system.debug('location code set by component:'+cow.LocationCode);
        system.debug('location code Fetched:'+iclmlist[0].Location_Code__c);
        //Assert if the claim supplied location is same as the location coming from the component
        System.assertequals(cow.LocationCode,iclmlist[0].Location_Code__c);

     }
}