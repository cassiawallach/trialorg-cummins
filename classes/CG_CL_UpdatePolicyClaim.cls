/*
 * Block comments with details of changes
 */
public class CG_CL_UpdatePolicyClaim
{

    @InvocableMethod(label='updateClaimsPolicy' description='Update claims policy')
    public static void updateClaimsPolicy(List<Id> cId){
        system.debug('inside updateClaimsPolicy Invocable method');
        set<String> policyACset = new set<String>();  
        List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c,Attribute2__c, Attribute3__c, Attribute4__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' AND Attribute1__c ='POL' ];
        if(jobEventTemp != null && jobEventTemp.size() > 0){
            for(CSS_JobEventTemporary__c temp : jobEventTemp) {
                policyACset.add(temp.Attribute2__c + ' ' + temp.Attribute3__c);
            }
        }

        system.debug('policyACset' + '  '+ policyACset);

        Map<Id, list<CSS_Solution_Component__c>> ClaimsSCMap = new Map<Id, list<CSS_Solution_Component__c>>();
        List<CSS_Solution_Component__c> solutionList = [Select id,AccountCode__c,CSS_Account_Formula__c,CSS_CoverageType__c, CSS_Claims__c 
                                                        from CSS_Solution_Component__c where CSS_Claims__c IN :cId ];//order by CSS_Claims__c

        system.debug('solutionList' + '  ' + solutionList);
        List<CSS_Solution_Component__c> tempSCList;
        if(solutionList != null && solutionList.size()>0){
            for(CSS_Solution_Component__c sol : solutionList) {
                if(ClaimsSCMap.containsKey(sol.CSS_Claims__c)) {
                    tempSCList = ClaimsSCMap.get(sol.CSS_Claims__c);
                    tempSCList.add(sol);
                } else {
                    tempSCList = new List<CSS_Solution_Component__c>();
                    tempSCList.add(sol);
                    ClaimsSCMap.put(sol.CSS_Claims__c, tempSCList);
                }
            }
        }

        system.debug('ClaimsSCMap' + '  ' + ClaimsSCMap);

        set<Id> updateClaimIdSet = new set<Id>();
        Boolean isPolicyClaim;
        if(ClaimsSCMap != null && ClaimsSCMap.size() >0) {
            for(Id claimsId : ClaimsSCMap.keyset()) {
                List<CSS_Solution_Component__c> tempSCLists = ClaimsSCMap.get(claimsId);
                system.debug('tempSCLists' + '  ' + tempSCLists);
                if(tempSCLists.size()>0){
                    for(CSS_Solution_Component__c sol : tempSCLists) {
                        if(policyACset.contains(sol.CSS_Account_Formula__c)){
                            system.debug('inside contains from JEvent from solcomp');
                            updateClaimIdSet.add(claimsId);
                            isPolicyClaim =true;
                            break;
                        }
                        else{
                            isPolicyClaim =false;
                        }
                    }
                }
            }
        }
        system.debug('updateClaimIdSet ' + '   ' + updateClaimIdSet);
        list<CSS_Claims__c> claimPolicyList = new list<CSS_Claims__c>();
        
        if(isPolicyClaim == true){
            for(Id claimsId : updateClaimIdSet) {
                CSS_Claims__c claimPol = new CSS_Claims__c();
                claimPol.id = claimsId;
                claimPol.PolicyClaim__c = true;
                claimPolicyList.add(claimPol);
            }
        }
        else
        {
            system.debug(' inside else isPolicyClaim' + ' ' + isPolicyClaim);
            CSS_Claims__c claimPol = new CSS_Claims__c();
            claimPol.id = cId[0];
            system.debug(' claimPol.id' + ' ' + claimPol.id);
            claimPol.PolicyClaim__c = false;
            claimPolicyList.add(claimPol);
        }


        if(claimPolicyList != null && claimPolicyList.size() >0)
            update claimPolicyList;
        system.debug('claimPolicyList' +  '  ' + claimPolicyList);

    }
}