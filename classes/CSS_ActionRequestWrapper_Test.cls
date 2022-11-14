@isTest
private class CSS_ActionRequestWrapper_Test {

    static testmethod void CSS_ActionRequestWrapper_TestMethod(){
    CSS_srt__c srt = new CSS_srt__c();
    List<CSS_SRT__c> SRTList = new List<CSS_SRT__c>();
        srt.Name = 'Test';
        SRT.SRT_Type__c='Diagnosis';
        SRT.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
             SRT.SRT_ID__c='asd';
             SRT.SRT_Access_Code__c='asdf';
        SRT.Step_Description__c='hgfr';
             //repSRT.Job_Order__c='CSS-00013323';
             SRT.SRT_Quantity__c=1;
             SRT.isPerformed__c=True;
             SRT.SRT_Time__c=1.1;
             SRTList.add(SRT);
         insert SRTList;
        //CSS_ActionRequestWrapper caw= new cSS_ActionRequestWrapper(SRTList, '5');
             test.startTest();
       // caw.CSS_ActionRequestWrapper(SRTList, '5');
       CSS_ActionRequestWrapper caw= new cSS_ActionRequestWrapper(SRTList, '5');
        test.stopTest();
        
    }
}