@isTest
public class FSL_getDiagnosticTargetTime_Test {
        static testmethod void getDiagnosticTargetTimeTestMethod(){
        //Creating Test Data
        Css_job_order__c Job = CSS_TestData.createJobOrder(true);
        css_solutions__c Sol = CSS_TestData.createSolutions(true,Job.id);
        
        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = job.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;
        CSS_SymptomQA__c symqa12=new CSS_SymptomQA__c();
        symqa12.job_order__c = job.id;
        symqa12.type__c='SearchString';
        symqa12.user_name__c = null;
        symqa12.name='TESST';
        symqa12.Caption__c = 'akanksha';
        insert symqa12;
        
        CSS_SymptomQA__c symqa2=new CSS_SymptomQA__c();
        symqa2.job_order__c = job.id;
        symqa2.type__c='SearchString';
        symqa2.user_name__c = null;
        symqa2.name='TESST';
        symqa2.SearchString__c = symqa12.id;
        symqa2.Caption__c = 'akanksha';
        insert symqa2;
        
        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();
        
        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,job.Id);
        solRef2.Repair_Response__c='Sucessful';
        solRef2.FaultCode__c=fc3.id;
        solref2.Symptom__c=symqa12.id;
        
        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,job.Id);
        solRef3.Repair_Response__c=null;
        solRef3.FaultCode__c=fc3.id;
        solref3.Symptom__c=symqa2.id;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist; 
        
       
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();  
        reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Engine';
        reqWrapper.Path = '/diagnostictargettime';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
        reqWrapper.timeOut = 120000;
        
        List<String> solIds = new List<String>();
        solIds.add(solref2.Id);
        solIds.add(solref3.Id);
        
        Set<String> solIdsSet = new set<String>();
        solIdsSet.add(solref2.Id);
        solIdsSet.add(solref3.Id); 
        test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        
        Test.StartTest();
		Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_getDiagnosticTargetTime.getDiagnosticTargetTime(solIdsSet,'EQ6837','ISX15 CM2350 X101','10','en');
        Test.stopTest();
    }

}