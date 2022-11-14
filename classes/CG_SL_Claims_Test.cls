@isTest
public class CG_SL_Claims_Test {
    
     public static testmethod void CG_SL_Claims_Test()
     {
         Test.startTest();
         
         CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
         csInt.name = 'SiebelClaimHistory';
         csInt.ApplicationName__c='SiebelClaimHistory';
         csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/history';
         csInt.IsActive__c=true;
         csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
         csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
         csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
         insert csint;
            
         //OAG Wrapper
         CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
         OPWrap = CG_SL_Claims.claimHistoryWebservice('79659993');
         OPWrap = CG_SL_Claims.calloutGenericMuleNamedCredClaimHist('79659993');
         //  OPWrap = cg_sl_bms.sendMISCCharges('79393939');
     
    	 CG_SL_Claims slclaims = new CG_SL_Claims();        
         test.stopTest();
         
    }
    
    /*public static testmethod void CG_SL_Claims_Test1()
     {
      Test.startTest();
      CG_OP_OAGWrapper OPWrap1 = new CG_OP_OAGWrapper();
       OPWrap1 = CG_SL_Claims.claimHistoryWebservice(''); 
       OPWrap1.exceptionFlag = true;  
        test.stopTest();
    }*/
    public static testmethod void exceptionMethod(){
        Test.startTest();
        try{
        CG_OP_OAGWrapper oag5=CG_SL_Claims.claimHistoryWebservice(null);
        //oag5.exceptionFlag = true;
       }catch(Exception e){
         
       }
    }
 }