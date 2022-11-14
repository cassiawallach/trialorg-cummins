@istest
public class CSS_AutoAddAdminSRT_Test {
    static TestMethod void testautoaddAdminSRT() {
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
        CSS_SRT__c SRT = new CSS_SRT__c();
					srt.Job_Order__c = JO.id;
                    srt.SRT_AccessiblityCheck__c=True;
                    srt.Access_Code_A__c = 65;
                    srt.name = 'TestClassName';
					srt.type__c = 'Admin';
           			srt.Assignment__c = 'PRIMARY';
           			srt.srt_time__c = 1;
           			srt.SRT_ID__c = '00-901-10';
		           	srt.isPerformed__c = true;
        insert srt;
        CSS_SRT__c SRT1 = new CSS_SRT__c();
                    srt1.Job_Order__c = JO.id;
                    srt1.SRT_AccessiblityCheck__c=True;
                    srt1.Access_Code_A__c = 65;
                    srt1.name = 'TestClassName';
					srt1.type__c = 'Admin';
           			srt1.Assignment__c = 'PRIMARY';
           			srt1.srt_time__c = 1;
           			srt1.SRT_ID__c = '00-902-10';
					srt1.isPerformed__c = true;
           insert srt1;
          
       
        
           Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
           Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
    Test.startTest();
        List<String> input = new List<String>();
        string str = 'test';
        string str1 = 'test1';
        input.add(str);
        input.add(str1);
         Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
           Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        css_AutoAddAdminSRT.getAdminSRTs(input);
        css_AutoAddAdminSRT.SRTCalloutAndInsert(JO.id,'In Shop','310 – Recreational Vehicle');
        //css_AutoAddAdminSRT.SRTCalloutAndInsert(JO.id,'Mobile','');
        css_AutoAddAdminSRT.SRTCalloutAndInsertInsiteAdminSRT(JO.id);
       
        
        Test.stopTest();
    }
    static TestMethod void testautoaddAdminSRT1() {
        
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
        CSS_SRT__c SRT = new CSS_SRT__c();
          
                    srt.Job_Order__c = JO.id;
                    srt.SRT_AccessiblityCheck__c=True;
                    srt.Access_Code_A__c = 65;
                    srt.name = 'TestClassName';
					srt.type__c = 'Admin';
           			srt.Assignment__c = 'PRIMARY';
           srt.srt_time__c = 1;
           srt.SRT_ID__c = '00-901-10';
           //srt.Component_id__c = solcomp.id;
           srt.isPerformed__c = true;
           insert srt;
        CSS_SRT__c SRT1 = new CSS_SRT__c();
                            srt1.Job_Order__c = JO.id;
                    srt1.SRT_AccessiblityCheck__c=True;
                    srt1.Access_Code_A__c = 65;
                    srt1.name = 'TestClassName';
					srt1.type__c = 'Admin';
           			srt1.Assignment__c = 'PRIMARY';
           srt1.srt_time__c = 1;
           srt1.SRT_ID__c = '00-902-10';
           //srt.Component_id__c = solcomp.id;
           srt1.isPerformed__c = true;
           insert srt1;
       
       Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
           Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
       Test.startTest();
        List<String> input = new List<String>();
        //string str = 'test'+';;'+'test1';
        string str = 'test';
        string str1 = 'test1';
        input.add(str);
        input.add(str1);
         Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
           Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        css_AutoAddAdminSRT.getAdminSRTs(input);
        //css_AutoAddAdminSRT.SRTCalloutAndInsert(JO.id,'In Shop','310 – Recreational Vehicle');
        css_AutoAddAdminSRT.SRTCalloutAndInsert(JO.id,'Mobile','');
        css_AutoAddAdminSRT.SRTCalloutAndInsertInsiteAdminSRT(JO.id);

            
        
        Test.stopTest();
    }
}