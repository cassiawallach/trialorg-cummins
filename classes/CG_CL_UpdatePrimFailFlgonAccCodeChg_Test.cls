@isTest
public class CG_CL_UpdatePrimFailFlgonAccCodeChg_Test {
    public static testMethod void CG_CL_UpdatePrimFailFlgonAccCodeChg_Method(){
        Test.starttest();
        
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.AccessCode__c = 'Test';
        claims.Address__c = 'Bangalore';
        claims.Catastrophic__c = True;
        insert claims;
        system.debug('claimsID' + claims.id );
        List<CSS_Solution_Component__c> solCompList = new list<CSS_Solution_Component__c>();    
        
        List<String> solCompId = new List<String>();
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.CSS_Claims__c = claims.Id;
        solcomp.AccountCode__c = 'NEW PARTS WARRANTY 62';
        solcomp.Fail_Code_Editable__c = 'THAC';
        solcomp.AccountCode_Call_Status__c = 'Test';
        solcomp.AccountCodeType__c = 'NEW PARTS WARRANTY 62'; 
        solcomp.AccountCodeEdit__c =  'NEW PARTS WARRANTY 62';
        solcomp.CSS_Primary_Failure__c = False;
        insert solcomp;
        //solCompId.add(solcomp.Id+';;'+solcomp.AccountCodeEdit__c);
        //solCompList.add(solcomp);
        //solcomp = [select id,name,AccountCodeType__c,AccountCodeEdit__c,CSS_Account_Formula__c from CSS_Solution_Component__c];
        system.debug('solcomp.CSS_Account_Formula__c****' + solcomp.CSS_Account_Formula__c);
        List<CSS_Solution_Component__c> solCompList1 = new list<CSS_Solution_Component__c>();    
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.CSS_Claims__c = claims.Id;
        //solcomp1.AccountCode__c = 'NEW PARTS WARRANTY 35';
        solcomp1.Fail_Code_Editable__c = 'THAC';
        solcomp1.AccountCode_Call_Status__c = 'Test';
        solcomp1.AccountCodeType__c = 'NEW PARTS WARRANTY 35'; 
        solcomp1.AccountCodeEdit__c =  'NEW PARTS WARRANTY 35';
        solcomp1.CSS_Primary_Failure__c = False;
        insert solcomp1;
        solCompId.add(claims.Id+';;'+solcomp1.AccountCodeEdit__c);
        solCompList.add(solcomp1);
        //solCompList1.add(solcomp1);
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
        solcomp2.CSS_Claims__c = claims.Id;
        solcomp2.AccountCode__c = 'NEW PARTS WARRANTY 35';
        solcomp2.Fail_Code_Editable__c = 'THAC';
        solcomp2.AccountCode_Call_Status__c = 'Test';
        solcomp2.AccountCodeType__c = 'NEW PARTS WARRANTY 35'; 
        solcomp2.AccountCodeEdit__c =  'NEW PARTS WARRANTY 35';
        solcomp2.CSS_Primary_Failure__c = False;
        //insert solcomp1;
        solCompList1.add(solcomp2);
        insert solCompList1;
        //String[] splitSolComp = [solcomp.Id, solcomp.AccountCodeEdit__c];
        List<String> solCompId1 = new List<String>();
        solCompId1.add(solCompList1[0].id);
        solCompId1.add(solCompList[0].id);
        CG_CL_UpdatePrimFailFlgonAccCodeChg.UpdatePrimaryFailureFlagonAccCodeChange(solCompId);
        Test.stopTest();
    }
     public static testMethod void CG_CL_UpdatePrimFailFlgonAccCodeChg_Method1(){
         CG_CL_UpdatePrimFailFlgonAccCodeChg.UpdatePrimaryFailureFlagonAccCodeChange(null);
     }
}