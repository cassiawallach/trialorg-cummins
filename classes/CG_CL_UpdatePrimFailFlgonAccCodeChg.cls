public class CG_CL_UpdatePrimFailFlgonAccCodeChg {
        
    @InvocableMethod(label='updateprimaryFailureFlag' description='Update primary failure flag when account code is changed') 
    public static void UpdatePrimaryFailureFlagonAccCodeChange(List<String> solCompId){
        system.debug('solCompId'+solCompId);
        String[] splitSolComp;
        CSS_Solution_Component__c solCompRec;
        List<CSS_Solution_Component__c> solCompList = new list<CSS_Solution_Component__c>();
        List<CSS_Solution_Component__c> updateSolCompList = new list<CSS_Solution_Component__c>();
        try{
        splitSolComp = solCompId[0].split(';;');
        String claimId = (splitSolComp != null && splitSolComp.size()>0 ? splitSolComp[0] : '');
        String AccCode = (splitSolComp != null && splitSolComp.size()>0 ? splitSolComp[1] : '');
        if(claimId != null && claimId != ''){
        solCompList = [select id,CSS_Primary_Failure__c,CSS_Account_Formula__c,CSS_Claims__c from 
                                        CSS_Solution_Component__c where CSS_Claims__c =: claimId and CSS_Account_Formula__c =: AccCode];
        
            for(CSS_Solution_Component__c tempSolComp:solCompList){
                solCompRec = new CSS_Solution_Component__c();
                solCompRec.Id = tempSolComp.Id;
                solCompRec.CSS_Primary_Failure__c = false;
                updateSolCompList.add(solCompRec);
            }
            if(updateSolCompList != null && updateSolCompList.size()>0){
                update updateSolCompList;
            }
        }
    }catch(exception e){
        system.debug('Entered into catch block of UpdatePrimaryFailureFlagonAccCodeChange method in CG_CL_UpdatePrimFailFlgonAccCodeChg class'+e.getMessage()+' '+e.getLineNumber());
    }
  }
}