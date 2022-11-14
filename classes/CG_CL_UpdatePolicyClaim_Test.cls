@isTest
public class CG_CL_UpdatePolicyClaim_Test 
{
	static testmethod void M1()
    {
        //Create Job
        CSS_Job_Order__c testjob=CSS_TestData.createJobOrder(true);
        
        
        //Create Claim data
        css_claims__c clm1=CSS_TestData.createclaims(false,null);
        clm1.PolicyClaim__c=true;
        css_claims__c clm2=CSS_TestData.createclaims(false,null);
        clm2.PolicyClaim__c=true;
        list<css_claims__c> clsmlist=new list<css_claims__c>();
        clsmlist.add(clm1);    
		clsmlist.add(clm2); 
        insert clsmlist;
        list<id> clmsids=new list<id>();
        clmsids.add(clsmlist[0].id);
        clmsids.add(clsmlist[1].id);
        
        //Create Sol Data
        CSS_Solutions__c sol=CSS_TestData.createSolutions(true,testjob.id);

        
        //Create Sol Comp Data       
        CSS_Solution_Component__c solcom1= CSS_TestData.createSRT(false,null,sol.id);
        solcom1.css_claims__c=clsmlist[0].id;
        CSS_Solution_Component__c solcom2= CSS_TestData.createSRT(false,null,sol.id);  
        solcom2.css_claims__c=clsmlist[1].id;
        list<CSS_Solution_Component__c> solcomplist=new list<CSS_Solution_Component__c>();
        solcomplist.add(solcom1);
        solcomplist.add(solcom2);
        insert solcomplist;
        
        //Create JET Data 
        CSS_JobEventTemporary__c jetm1=new CSS_JobEventTemporary__c();
        CSS_JobEventTemporary__c jetm2=new CSS_JobEventTemporary__c();
        jetm1.Key__c='AccountCodes';
        jetm2.Key__c='AccountCodes';
        jetm1.Attribute1__c='POL';
        jetm2.Attribute1__c='POL';
        list<CSS_JobEventTemporary__c> jetlist=new list<CSS_JobEventTemporary__c>();
        jetlist.add(jetm1);
        jetlist.add(jetm2);
        insert jetlist;
        //Call the method to verify
        CG_CL_UpdatePolicyClaim.updateClaimsPolicy(clmsids);
    }
}