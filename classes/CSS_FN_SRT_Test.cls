//comment added for sept release 2022
@isTest
public class CSS_FN_SRT_Test {
    
    static testmethod void getFailureCodesSRTTest1() {
        CSS_FN_SRT SRTClass = new CSS_FN_SRT();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='SRT';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='SRT';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/standardrepairstime';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='yrkTEQTcVX59alQunY7vBFOCoMzhf+7mIBVF0LyE5J0=';
        conDetails.Passcode__c='UZvRxj9SjjcepsRMWDHhuQduplleXWBfrWhodykLHcOBMci7kZ+Pil8ZRfPCDz5vRH/JbvXoZ19qBi5A0EJ0oA==';
        conDetails.Username__c='gyr3X2qsCi4mIivcj4ndefGc5yNJn9+G8TSMoejZCitMlkQFo8DBQ4Ycy+gW6zsEnJVsmhPqBltCUnutiFXf7w==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        
        insert conDetails;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
        SRTClass.getFailureCodesSRT('ISC8.3 CM2250','41','en');
        Test.stopTest();
        
    }
    
    static testmethod void getFailureCodesSRTTest2() {
        CSS_FN_SRT SRTClass = new CSS_FN_SRT();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='SRT';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='SRT';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/standardrepairstime';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='yrkTEQTcVX59alQunY7vBFOCoMzhf+7mIBVF0LyE5J0=';
        conDetails.Passcode__c='UZvRxj9SjjcepsRMWDHhuQduplleXWBfrWhodykLHcOBMci7kZ+Pil8ZRfPCDz5vRH/JbvXoZ19qBi5A0EJ0oA==';
        conDetails.Username__c='gyr3X2qsCi4mIivcj4ndefGc5yNJn9+G8TSMoejZCitMlkQFo8DBQ4Ycy+gW6zsEnJVsmhPqBltCUnutiFXf7w==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        
        insert conDetails;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
        SRTClass.getFailureCodesSRT('ISC8.3 CM2250','41','en');
        Test.stopTest();
        
    }  
    
    static testmethod void getMakeModelEquipIdTestMethod(){
        //Creating Test Data
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='MakeModelEquipmentId';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='MakeModelEquipmentId';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/makemodelaccesslist';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='qS/H/A/XHhtBHSLKDDETqJzyJu+C5ZCQDgxMxaa2ElY=';
        conDetails.Passcode__c='KF5VGsUOaEoEm1RClJnx7+oiJr90hufKunr98KMGz4aEklXmZ9kef6Clj3BCH4Xk/TlgA5ALbS9faE+I5NOHCg==';
        conDetails.Username__c='1k4tpLdYgraGIfaxABQxW5q2/lPop+Xpe0WwtsS1MbpIeJNx30Pyyx+zDrXqiHB9DRBDHImTF6MtjjW9SVIdMA==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        
        insert conDetails;
        test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        
        test.setMock(HttpCalloutMock.class, new CSS_WS_OAGMock_Test());
        test.setMock(HttpCalloutMock.class , new CSS_WS_SRT_MakeModelEquipIdMock_Test());
        
        //CSS_WS_OAG.getAccessToken();
        
        Test.StartTest();
        //insert cid;
        
        CSS_FN_SRT.getMakeModalEquipmentIdList('2019-08-08');
        Test.stopTest();
    }
    
    static testmethod void srtPartsServiceTestMethod(){
        Css_job_order__c Job = CSS_TestData.createJobOrder(true);
        css_solutions__c Sol = CSS_TestData.createSolutions(true,Job.id);
        css_solutions__c Sol1 = CSS_TestData.createSolutions(true,Job.id);
        CSS_Solution_Component__c solcomp = CSS_TestData.CreateSRT(true,Job.id,Sol.id);
        CSS_Solution_Component__c solcomp1 = CSS_TestData.CreateSRT(true,Job.id,Sol.id);
        solcomp.Component_Id__c = 'F02000010';
        update solcomp;
        solcomp1.Component_Id__c = 'F02000010';
        update solcomp1;
        system.debug('KAL**'+solcomp);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        List<CSS_Solution_Component__c> solCompObj = new List<CSS_Solution_Component__c>();
        solCompObj.add(solcomp);
        solcompobj.add(solcomp1);
        CSS_Claims__c claims = CSS_TestData.createclaims(true,Job.id);
        CSS_PSN__c psn = CSS_TestData.createpsn(true,claims.id);
        css_parts_options__c parts = new css_parts_options__c();
        parts.name = 'Test';
        parts.Solutions__c = solCompObj[0].solutions__c;
        parts.service_job__c = Job.id;
        parts.option_number__c = 'Test';
        parts.Option_ESN__c = Job.esn__c;
        parts.recordtypeId = recTypeIdpart;
        parts.CSS_Claims__c = claims.id;
        insert parts;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='SRT';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='SRT';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/standardrepairstime';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='yrkTEQTcVX59alQunY7vBFOCoMzhf+7mIBVF0LyE5J0=';
        conDetails.Passcode__c='UZvRxj9SjjcepsRMWDHhuQduplleXWBfrWhodykLHcOBMci7kZ+Pil8ZRfPCDz5vRH/JbvXoZ19qBi5A0EJ0oA==';
        conDetails.Username__c='gyr3X2qsCi4mIivcj4ndefGc5yNJn9+G8TSMoejZCitMlkQFo8DBQ4Ycy+gW6zsEnJVsmhPqBltCUnutiFXf7w==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        
        insert conDetails;
        
        CSS_getPartsListSRTRequestJ2A getpartlstsrtwrap = new CSS_getPartsListSRTRequestJ2A();
        // Set mock callout class    
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.startTest();
        CSS_FN_SRT.srtPartsService(solCompObj,Job,recTypeIdpart);
        CSS_FN_SRT.fetchGSQServiceParts(solcomp,Job);
        //CSS_FN_SRT.GSQParts('');
        CSS_FN_SRT.FetchGSQParts(solComp.Id, Claims.id);
        //CSS_FN_SRT.getFieldActionSRT('Test', 'Test', 'Test', 'Test', solcompobj);
        Test.stopTest();
    }
    
    static testmethod void srtPartsServiceNew(){
        Css_job_order__c Job = CSS_TestData.createJobOrder(true);
        css_solutions__c Sol = CSS_TestData.createSolutions(true,Job.id);
        css_solutions__c Sol1 = CSS_TestData.createSolutions(true,Job.id);
        CSS_Solution_Component__c solcomp = CSS_TestData.CreateSRT(true,Job.id,Sol.id);
        CSS_Solution_Component__c solcomp1 = CSS_TestData.CreateSRT(true,Job.id,Sol.id);
        solcomp.Component_Id__c = 'F02000010';
        update solcomp;
        solcomp1.Component_Id__c = 'F02000010';
        update solcomp1;
        system.debug('KAL**'+solcomp);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        List<CSS_Solution_Component__c> solCompObj = new List<CSS_Solution_Component__c>();
        solCompObj.add(solcomp);
        solcompobj.add(solcomp1);
        CSS_Claims__c claims = CSS_TestData.createclaims(true,Job.id);
        CSS_PSN__c psn = CSS_TestData.createpsn(true,claims.id);
        css_parts_options__c parts = new css_parts_options__c();
        parts.name = 'Test';
        parts.Solutions__c = solCompObj[0].solutions__c;
        parts.service_job__c = Job.id;
        parts.option_number__c = 'Test';
        parts.Option_ESN__c = Job.esn__c;
        parts.recordtypeId = recTypeIdpart;
        parts.CSS_Claims__c = claims.id;
        insert parts;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='SRT';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='SRT';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/standardrepairstime';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='yrkTEQTcVX59alQunY7vBFOCoMzhf+7mIBVF0LyE5J0=';
        conDetails.Passcode__c='UZvRxj9SjjcepsRMWDHhuQduplleXWBfrWhodykLHcOBMci7kZ+Pil8ZRfPCDz5vRH/JbvXoZ19qBi5A0EJ0oA==';
        conDetails.Username__c='gyr3X2qsCi4mIivcj4ndefGc5yNJn9+G8TSMoejZCitMlkQFo8DBQ4Ycy+gW6zsEnJVsmhPqBltCUnutiFXf7w==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        
        insert conDetails;
        
        CSS_getPartsListSRTRequestJ2A getpartlstsrtwrap = new CSS_getPartsListSRTRequestJ2A();
        // Set mock callout class    
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.startTest();
        CSS_FN_SRT.srtPartsServiceNew(solCompObj,Job,recTypeIdpart);
        
        Test.stopTest();
    }
    
    static testmethod void catchblockmethod(){
        CSS_FN_SRT.srtPartsService(null,null,null);
        CSS_FN_SRT.fetchGSQServiceParts(null,null);
        //CSS_FN_SRT.GSQParts('');
        CSS_FN_SRT.FetchGSQParts(null, null);
        CSS_FN_SRT.getFieldActionSRT(null, null, null, null, null);
        
    }
    
    static testmethod void getFieldActionSRTTestMethod(){
        //Creating Test Data
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='CG_FieldActionSRT';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='CG_FieldActionSRT';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/fieldactions';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='ZFREASYzr0a8dvZeweLEcZFt0WGVSw4y3UPn94MgyfY=';
        conDetails.Passcode__c='NrPVeuWQ8wBoI5gfrP/HKf09xDn/Ax4jomZ2OO6V0IQOOOjpN1F1UFVJ7rmef07kx8HwplNve292Hw1q5RZuDw==';
        conDetails.Username__c='nzLg/MHq8izrXlABWXJXXEbblfc9fX5Z9c6y9yb2+SflE8gkGtCNdtfbuQ04OTlUjQk9Amp4a8yFYcjnjIaxLA==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';        
        insert conDetails;
        
        Css_job_order__c Job = CSS_TestData.createJobOrder(true);
        css_solutions__c Sol = CSS_TestData.createSolutions(true,Job.id);
        List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
        
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,Job.Id,sol.Id);
        solComRef.System_Code__c = 'WF';
        solComRef.Component_Code__c = 'IF';
        solComRef.Failure_Mode__c = 'SC';
        solComRef.Solutions__c =sol.id;
        solComRef.AccountCode_Call_Status__c = 'Success';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = '65';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        solComRef.Component_Id__c = '2048';
        solComRef.selected_component__c = true;
        solComRef.Type__c='CAMPAIGN';
        solComRef.AccountCodeType__c = 'CAMPAIGN';
        solComRef.AccountCodeEdit__c='CAMPAIGN 65';
        solComp.add(solComRef);
        
        
        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,job.Id,sol.Id);
        solComRef.System_Code__c = 'WF';
        solComRef1.Component_Code__c = 'LC';
        solComRef1.Failure_Mode__c = 'BA';
        solComRef1.Solutions__c =sol.id;
        solComRef1.AccountCode_Call_Status__c = 'Success';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();        
        solComRef1.Component_Id__c = '2062';
        solComRef1.selected_component__c = true;
        solComRef1.Type__c='CAMPAIGN';
        solComRef1.AccountCodeType__c = 'CAMPAIGN';
        solComRef1.AccountCodeEdit__c='CAMPAIGN 65';
        solComp.add(solComRef1);
        insert solComp;        
        
        test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        
        Test.StartTest();
        CSS_FN_SRT.getFieldActionSRT('ISX15 CM2350 X101','10','en','EQ8721',solComp);
        Test.stopTest();
    }
    
    static testmethod void getDiagnosticTargetTimeTestMethod(){
        //Creating Test Data
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='CG_GetDiagTargetTime';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='CG_GetDiagTargetTime';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/diagnostictargettime';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='jxgr95gUNWv0waKVVsmxpDW4ADHD/mqrmUCUx4eEdRU=';
        conDetails.Passcode__c='u7Uds6YjZn6POuKbSL8ICQiV/MhCThQ+2qnyhDCy/7KBhQXr4Ix/5d+tWxORHYP31D2pXbRnle6ZEJGkaoyU0A==';
        conDetails.Username__c='tpte7KV3tCma7wr8ojmUlgOwnk5zbsG4PrlVFXHDOpLp2h1gsUGhfdVsm/bRJ8Dzar8JO3bfHwhkB+A1TWWVNQ==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';        
        insert conDetails;
        
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
        
        List<String> solIds = new List<String>();
        solIds.add(solref2.Id);
        solIds.add(solref3.Id);
        
        Set<String> solIdsSet = new set<String>();
        solIdsSet.add(solref2.Id);
        solIdsSet.add(solref3.Id); 
        test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        
        Test.StartTest();
        CSS_FN_SRT.getDiagnosticTargetTime(solIds,'EQ6837','ISX15 CM2350 X101','10','en');
        CSS_FN_SRT.getDiagnosticTargetTime(solIdsSet,'EQ6837','ISX15 CM2350 X101','10','en');
        Test.stopTest();
    }
}