/* Purpose : Test class for CG_CL_UpdatePACCARFlagServiceJob by Venkat Gantasala */
@isTest
public class CG_CL_UpdatePACCARFlagServiceJob_Test {
	
    public static testmethod void updatePaccarFlag(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Wenchin';
        acc.Type = 'Dealer Account';
        insert acc;
        // Test Data for Service Job 
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        jo.Account__c = acc.id;
        jo.SP_PACCAR__c = 'N';
        update jo;
        CSS_Job_Order__c jo1 = CSS_TestData.createJobOrder(false);
        jo1.Id = jo.id;
        List<String> lstString = new List<String>();
        lstString.add(jo.Id);
        lstString.add(jo1.Id);
        
        List<CSS_Accreditation__c> lstAccrediation = new List<CSS_Accreditation__c>();
        CSS_Accreditation__c accrediation = new CSS_Accreditation__c();
        accrediation.OEM_Code__c = '68';
        accrediation.StartDate__c = jo.Failure_Date__c;
        accrediation.EndDate__c = jo.Failure_Date__c;
        accrediation.Account__c = jo.Account__c;
        insert accrediation;
        lstAccrediation.add(accrediation);
        CG_CL_UpdatePACCARFlagServiceJob updatePaccar = new CG_CL_UpdatePACCARFlagServiceJob();
        
        CG_CL_UpdatePACCARFlagServiceJob.updatePACCARFlag(lstString);
        CG_CL_UpdatePACCARFlagServiceJob.setPACCAR_Flag();
        Test.stopTest();
    }
    public static testmethod void updatePaccarFlag1(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Wenchin';
        acc.Type = 'Dealer Account';
        insert acc;
        // Test Data for Service Job 
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        jo.Account__c = acc.id;
        jo.PSN_PACCAR_Flag__c = 'N';
        update jo;
        CSS_Job_Order__c jo1 = CSS_TestData.createJobOrder(false);
        jo1.Id = jo.id;
        List<String> lstString = new List<String>();
        lstString.add(jo.Id);
        lstString.add(jo1.Id);
      
        CG_CL_UpdatePACCARFlagServiceJob.updatePACCARFlag(lstString);
        Test.stopTest();
    }
}