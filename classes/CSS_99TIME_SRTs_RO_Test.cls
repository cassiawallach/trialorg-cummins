@isTest
public class CSS_99TIME_SRTs_RO_Test {
    public static testmethod void method1(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(false);
        jo.Account__c = acc.id;
        insert jo;
        Id Wid=ApexPages.CurrentPage().getParameters().put('id',jo.id);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jo.Id);
        CSS_SRT__c srt = CSS_TestData.createSRT(false,'type',sol.id,jo.Id);
        srt.Account_Code_Description__c = 'test';
        srt.FailCode__c = 'test';
        srt.Fail_Code_Description__c = 'test';
        srt.SRT_Time__c = 12345666;
        srt.SRT_Warrantable__c = '1';
        srt.SRT_Notes__c = 'test';
        srt.SRT_Estimate__c = true;
        srt.Type__c = '99Time';
        insert srt;
        
        system.debug('wid'+Wid);
        CSS_99TIME_SRTs_RO.NonSRTWrapper wrap = new CSS_99TIME_SRTs_RO.NonSRTWrapper(2,'srtId','SRTCode','SRTTime','percentRequested','failCode','accountCode','Notes');
        CSS_99TIME_SRTs_RO srtTime = new CSS_99TIME_SRTs_RO();
        srtTime.gotoJobPlanSrt();
        
    }
}