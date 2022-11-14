@isTest
public class CSS_SRT_Test{
    
    static testMethod void testDiagSRTcase1(){
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='OAGOAuth';
        condetails.ApplicationName__c='OAGOAuth';
        condetails.AuthEnv__c='OAGOAuth';
        condetails.End_Point__c='https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails);
        CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
        condetails1.name='Mule Send data';
        condetails1.ApplicationName__c='Mule Soft';
        condetails1.AuthEnv__c='ad724392-5594-4e85-b9eb-b0fc19c2fabe';
        condetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails1.grant_type__c='Refresh_full';
        condetails1.IsActive__c=true;
        condetails1.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Logging__c='BOTH';
        condetails1.Method_Type__c='POST';
        condetails1.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Timeout__c=120;
        condetails1.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails1);
        insert recs; 
        
        test.starttest();
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        String json1 = '{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"\",'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"VER\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"\"],'+
            '                  \"SRTStatusMessage\": \"An SRT is not being populated for this EDS Solution as this time overlaps with Administration Time (00-90X), Insite (00-724), or may be included with other Diagnostic Session SRTs.\",'+
            '                  \"StepID\": 0,'+
            '                  \"SRTTime\":                   {'+
            '                     \"SpecialAccessCode\": \"\",'+
            '                     \"SpecialAccessCodeDescription\": [\"\"],'+
            '                     \"AccessCodeB\": 0,'+
            '                     \"AccessCodeA\": 0,'+
            '                     \"AccessCodeD\": 0,'+
            '                     \"AccessCodeR\": 0,'+
            '                     \"AccessCodeC\": 0'+
            '                  }'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
            '            },'+
            '            \"SRTID\": \"\",'+
            '            \"CaseNumber\": \"K20430055\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Rocker Lever Cover - Remove and Install\",'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"VER\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 1,'+
            '                  \"SRTModifyDateTime\": \"2015-01-07T13:41:50.000-05:00\",'+
            '                  \"StepDescription\":                   ['+
            '                     \"Step Number-00\",'+
            '                     \"Includes:\",'+
            '                     \"-03-801 Crankcase Breather  -Remove and Install\",'+
            '                     \"\",'+
            '                     \"-Disconnect and connect batteries\",'+
            '                     \"-Remove and Install:\",'+
            '                     \". Air crossover pipes, as necessary\",'+
            '                     \". Air intake piping\",'+
            '                     \". Rocker lever cover\",'+
            '                     \"\",'+
            '                     \"-Clean and visually check:\",'+
            '                     \". Rocker lever cover\",'+
            '                     \". Rocker lever cover gasket surface\",'+
            '                     \"-Visually check:\",'+
            '                     \". Overhead components\",'+
            '                     \"-Operate engine to check for leaks and proper\",'+
            '                     \"operation\",'+
            '                     \"Note:  Refer to the following repair procedures\",'+
            '                     \"and time as necessary:\",'+
            '                     \"-19-045 Aftertreatment Intake Nox Sensor  -Remove\",'+
            '                     \"and Install\"'+
            '                  ],'+
            '                  \"SRTStatusMessage\": \"SRT is present\",'+
            '                  \"StepID\": 128418,'+
            '                  \"SRTTime\":                   {'+
            '                     \"SpecialAccessCode\": \"\",'+
            '                     \"SpecialAccessCodeDescription\": [\"\"],'+
            '                     \"AccessCodeB\": 0.9,'+
            '                     \"AccessCodeA\": 0.8,'+
            '                     \"AccessCodeD\": 1.1,'+
            '                     \"AccessCodeR\": 0,'+
            '                     \"AccessCodeC\": 1'+
            '                  }'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
            '            },'+
            '            \"SRTID\": \"03-122\",'+
            '            \"CaseNumber\": \"K20430055\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Resistance Measurements Using a Multimeter and Wiring Diagram, Each Four\",'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"VER\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 1,'+
            '                  \"SRTModifyDateTime\": \"2015-01-07T13:41:50.000-05:00\",'+
            '                  \"StepDescription\":                   ['+
            '                     \"Step Number-00\",'+
            '                     \"Includes:\",'+
            '                     \"\",'+
            '                     \"-Disconnect and connect:\",'+
            '                     \". Connector halves, if applicable\",'+
            '                     \". Multimeter probes or clips to appropriate\",'+
            '                     \"source\",'+
            '                     \"-Measure Resistance\"'+
            '                  ],'+
            '                  \"SRTStatusMessage\": \"SRT is present\",'+
            '                  \"StepID\": 96551,'+
            '                  \"SRTTime\":                   {'+
            '                     \"SpecialAccessCode\": \"\",'+
            '                     \"SpecialAccessCodeDescription\": [\"\"],'+
            '                     \"AccessCodeB\": 0.1,'+
            '                     \"AccessCodeA\": 0.1,'+
            '                     \"AccessCodeD\": 0.1,'+
            '                     \"AccessCodeR\": 0.1,'+
            '                     \"AccessCodeC\": 0.1'+
            '                  }'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
            '            },'+
            '            \"SRTID\": \"19-360\",'+
            '            \"CaseNumber\": \"K20430055\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Component Connector and Pin - Inspection, Each Four\",'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"VER\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 1,'+
            '                  \"SRTModifyDateTime\": \"2015-01-07T13:41:50.000-05:00\",'+
            '                  \"StepDescription\":                   ['+
            '                     \"Step Number-00\",'+
            '                     \"\",'+
            '                     \"Note: The following SRTs are NOT included in the\",'+
            '                     \"total time above, but may apply if the work is\",'+
            '                     \"required per CUMMINS published guidelines,\",'+
            '                     \"perfromed and explained on the claim:\",'+
            '                     \"\",'+
            '                     \"-Troubleshoot  -Inactive or Intermittent\",'+
            '                     \"Fault Code(s)\",'+
            '                     \"Includes:\",'+
            '                     \"\",'+
            '                     \"-Connect and disconnect:\",'+
            '                     \". Component or harness connector halves\",'+
            '                     \"-Clean and inspect connector and pin\"'+
            '                  ],'+
            '                  \"SRTStatusMessage\": \"SRT is present\",'+
            '                  \"StepID\": 96550,'+
            '                  \"SRTTime\":                   {'+
            '                     \"SpecialAccessCode\": \"\",'+
            '                     \"SpecialAccessCodeDescription\": [\"\"],'+
            '                     \"AccessCodeB\": 0.1,'+
            '                     \"AccessCodeA\": 0.1,'+
            '                     \"AccessCodeD\": 0.1,'+
            '                     \"AccessCodeR\": 0.1,'+
            '                     \"AccessCodeC\": 0.1'+
            '                  }'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
            '            },'+
            '            \"SRTID\": \"19-361\",'+
            '            \"CaseNumber\": \"K20430055\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"\",'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"VER\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"\"],'+
            '                  \"SRTStatusMessage\": \"An SRT is not being populated for this EDS Solution as this time overlaps with Administration Time (00-90X), Insite (00-724), or may be included with other Diagnostic Session SRTs.\",'+
            '                  \"StepID\": 0,'+
            '                  \"SRTTime\":                   {'+
            '                     \"SpecialAccessCode\": \"\",'+
            '                     \"SpecialAccessCodeDescription\": [\"\"],'+
            '                     \"AccessCodeB\": 0,'+
            '                     \"AccessCodeA\": 0,'+
            '                     \"AccessCodeD\": 0,'+
            '                     \"AccessCodeR\": 0,'+
            '                     \"AccessCodeC\": 0'+
            '                  }'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
            '            },'+
            '            \"SRTID\": \"\",'+
            '            \"CaseNumber\": \"K91452265\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"2016-10-07T11:10:18.163-04:00\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"2016-10-07T11:10:18.163-04:00\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        CSS_Job_Order__c job1= new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',account__c=acc.id);
        CSS_Solutions__c solutions = new CSS_Solutions__c(Name='K43662142',Service_Job__c=job1.Id);
        insert job1;
        solutions.Service_Job__c=job1.id;
        //solutions.FSL_Service_Job__c=job1.id;
        insert solutions;
        
        
        List<CSS_SRT__C> SRTs = new List<CSS_SRT__c>();
        list<string> type= new list<string>{'Diagnosis','Repair'};
            integer index =0;
        for(integer i=0; i<10;i++){
            if(i>=type.size())index =0;
            CSS_SRT__C diagSRT = new CSS_SRT__C();
            diagSRT.Name ='Test';
            
            diagSRT.Type__c=type[index];
            diagSRT.SRT_Type__c=type[index];
            //diagSRT.Job_Order__c = JO.id;
            diagSRT.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
            diagSRT.SRT_ID__c='asd';
            diagSRT.SRT_Access_Code__c='asdf';
            diagSRT.Solution_Number__c= solutions.id; 
            diagSRT.Step_Description__c='Step Number-00';
            diagSRT.Job_Order__c=job1.Id;
            diagSRT.SRT_Quantity__c=1;
            diagSRT.isPerformed__c=True;
            diagSRT.SRT_Time__c=1.1;
            diagSRT.SRT_ORDER__C = 1;
            diagSRT.Assignment__c = 'PRIMARY';
            SRTs.add(diagSRT);
            index++;
        }
        insert SRTs;
        
        
        Map<ID,String> sol = new Map<ID,String>();
        Map<id,id> jobOrder = new Map<id,id>();
        sol.put(solutions.id,solutions.name);
        jobOrder.put(solutions.id,solutions.Service_Job__c);
        CSS_SRT.diagnosticSRT(jobOrder,sol,job1.service_model__c,'a',1.1,'accessjob');
        CSS_SRT.splreceiveToken('OAGOAuth');
        CSS_SRT.receiveToken();
        Test.stoptest();
        
    }
    
    static testMethod void testDiagSRTcase2A() {
        Test.setMock(HttpCalloutMock.class, new CSS_Diagnosis_SRT_Test());
        test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',account__c=acc.id);
        insert job1;
        solutions = new CSS_Solutions__c(Name='K43662142',Service_Job__c=job1.Id);
        insert solutions;
        
        
        Map<ID,String> sol = new Map<ID,String>();
        Map<id,id> jobOrder = new Map<id,id>();
        sol.put(solutions.id,solutions.name);
        jobOrder.put(solutions.id,solutions.Service_Job__c);
        //test.starttest();
        Boolean isRep = false;
        
        
        
        CSS_SRT.diagnosticSRT(jobOrder,sol,job1.service_model__c,'a',1.1,'b'); 
        Test.stoptest();
        
    }
    static testMethod void testDiagSRTcase2() {
        Test.setMock(HttpCalloutMock.class, new CSS_Diagnosis_SRT_Test());
        test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',account__c=acc.id);
        insert job1;
        solutions = new CSS_Solutions__c(Name='K43662142',Service_Job__c=job1.Id);
        insert solutions;
        
        List<CSS_SRT__C> SRTs = new List<CSS_SRT__c>();
        
        CSS_SRT__C diagSRT1 = new CSS_SRT__C();
        diagSRT1.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT1.Type__c='Diagnosis';
        diagSRT1.SRT_Type__c='Diagnosis';
        diagSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT1.SRT_ID__c='asd-00';
        diagSRT1.SRT_Access_Code__c='asdf';
        diagSRT1.Solution_Number__c= solutions.id; //K48722870;
        diagSRT1.Step_Description__c='Step Number-00';
        diagSRT1.Job_Order__c=job1.Id;
        diagSRT1.SRT_Quantity__c=1;
        diagSRT1.isPerformed__c=True;
        diagSRT1.SRT_Time__c=1.1;
        diagSRT1.SRT_ORDER__C = 1;
        diagSRT1.Assignment__c = 'PRIMARY';
        SRTs.add(diagSRT1);
        
        insert SRTs;
        List<CSS_SRT__C> SRTs1 = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        //repSRT.Component_Id__c='F05000100';
        repSRT1.Type__c='Repair';
        repSRT1.SRT_Type__c='Repair';
        repSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='asdf';
        // repSRT.Solution_Number__c= K48722870;
        repSRT1.Step_Description__c='Step Number-00';
        repSRT1.Job_Order__c=job1.Id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.SRT_Time__c=1.1;
        repSRT1.SRT_Order__c = 2;
        repSRT1.Assignment__c ='PRIMARY';
        insert repSRT1;
        SRTs1.add(repSRT1);
        Map<ID,String> sol = new Map<ID,String>();
        Map<id,id> jobOrder = new Map<id,id>();
        sol.put(solutions.id,solutions.name);
        jobOrder.put(solutions.id,solutions.Service_Job__c);
        //test.starttest();
        Boolean isRep = false;
        
        
        
        CSS_SRT.diagnosticSRT(jobOrder,sol,job1.service_model__c,'a',1.1,'b'); 
        Test.stoptest();
        
    }
    static testMethod void testRepairSrt222(){
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        string json2='{"DataArea":{"ResponseMessage":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination."},"Header":{"ReturnCodeDescription":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination.","Status":"Error"}}';
        String json1 ='{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"UNLISTED\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
            '                  \"StepID\": 120039'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-057-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
            '                  \"StepID\": 19684'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PRIMARY\",'+
            '            \"FlexSRT\": \"F\",'+
            '            \"ECMFlag\": \"F\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-109-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 2.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json2,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F07000130',Solutions__c=solutions.Id,Service_Job__c=job1.id, 
                                                System_Code__c = 'TH', Component_Code__c = 'AC', AccountCode__c ='Krishna 65',
                                                Selected_Component__c = true);
        insert solComp;
        system.debug('solComp'+solComp);
        Claim = new CSS_Claims__c();
        //CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        Claim.Customer_Name__c='TestCustomer';
        Claim.Customer_Code__c = '1234';
        Claim.Account__c = acc.id;
        Claim.Contact_Last_Name__c = 'T';
        Claim.Address__c = 'T';
        Claim.Account__c = acc.id;
        Claim.CSS_Job__c = job1.id;
        Claim.Customer_Contact_Phone__c = null;
        Claim.Email_Address__c = 'RdB@nomail.com';
        Claim.Status__c = 'Draft';
        //Claim.Account__c=acc.Id;
        insert Claim;
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        repsrt1.css_claims__c = Claim.id;
        repSRT1.SRT_Order__c=2;
        repairSRT.add(repSRT1);
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        repsrt2.css_claims__c = Claim.id;
        repSRT2.SRT_Order__c=411;
        repairSRT.add(repSRT2);
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repsrt3.css_claims__c = Claim.id;
        repSRT3.SRT_Order__c=413;
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT4.Name ='Test2';
        repSRT4.Component_Id__c=solComp.id;
        repSRT4.SRT_Type__c='Diag Access';
        repSRT4.Type__c='Diag Access';
        repSRT4.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT4.SRT_ID__c='asd-00';
        repSRT4.SRT_Access_Code__c='A';
        repSRT4.Solution_Number__c= solutions.id;
        repSRT4.Step_Description__c='hgfr';
        repSRT4.Job_Order__c=job1.id;
        repSRT4.SRT_Quantity__c=1;
        repSRT4.Access_Code__c='A';
        repSRT4.isPerformed__c=True;
        repSRT4.SRT_Time__c=1.1;
        repsrt4.css_claims__c = Claim.id;
        repSRT4.Assignment__c='PROGRESSIVE DAMAGE';
        repSRT4.SRT_Order__c=31;
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT5.Name ='Test2';
        repSRT5.Component_Id__c=solComp.id;
        repSRT5.SRT_Type__c='Diagnosis';
        repSRT5.Type__c='Diagnosis';
        repSRT5.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT5.SRT_ID__c='asd-00';
        repSRT5.SRT_Access_Code__c='A';
        repSRT5.Solution_Number__c= solutions.id;
        repSRT5.Step_Description__c='hgfr';
        repSRT5.Job_Order__c=job1.id;
        repSRT5.SRT_Quantity__c=1;
        repSRT5.Access_Code__c='A';
        repSRT5.isPerformed__c=True;
        repSRT5.SRT_Time__c=1.1;
        repSRT5.Assignment__c='PRIMARY';
        repsrt5.css_claims__c = Claim.id;
        repSRT5.SRT_Order__c=41;
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT6.Name ='Test3';
        repSRT6.Component_Id__c=solComp.id;
        repSRT6.SRT_Type__c='Diagnosis';
        repSRT6.Type__c='Diagnosis';
        repSRT6.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT6.SRT_ID__c='asd';
        repSRT6.SRT_Access_Code__c='A';
        repSRT6.Solution_Number__c= solutions.id;
        repSRT6.Step_Description__c='Step Number-00';
        repSRT6.Job_Order__c=job1.id;
        repSRT6.SRT_Quantity__c=1;
        repSRT6.SRT_Order__c=4;
        repSRT6.Access_Code__c='A';
        repSRT6.isPerformed__c=True;
        repSRT6.SRT_Time__c=1.1;
        repSRT6.Assignment__c='PRIMARY';
        repsrt6.css_claims__c = Claim.id;
        repairSRT.add(repSRT6);
        insert repairSRT;
        list<css_srt__c> srtlst = new list<css_srt__c>();
        CSS_SRT__C repSRT7 = new CSS_SRT__C();
        repSRT7.Job_Order__c=job1.id;
        repSRT7.SRT_ID__c='10-119-12';
        repSRT7.type__c='Repair Access';
        srtlst.add(repSRT7);
        insert srtlst;
        
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '50';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        CSS_JobEventTemporary__c jET2 = new CSS_JobEventTemporary__c();
        jET2.Attribute1__c = 'NPW';
        jET2.Attribute3__c = '60';
        jET2.Attribute4__c = 'DSBDV5789';
        jET2.Key__c = 'AccountCodes';
        jETList.add(jET2);
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        
        insert jETList;
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        List<string> solCompAdd = new List<string>();
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,claim.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','TYPE','3','7');
        CSS_SRT.solCompWrapper comp1 =new CSS_SRT.solCompWrapper(solComp.Solutions__c,claim.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','Campaign','3','7');
        solCompAdd.add(system.JSON.serialize(comp));
        solCompAdd.add(system.JSON.serialize(comp1));
        CSS_SRT.repairSRT(solCompAdd);
        CSS_SRT.repairSRTManualClaim(solCompAdd);
        
        test.stopTest();
    }
    static testMethod void testRepairSrt(){
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        String json1 ='{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"UNLISTED\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
            '                  \"StepID\": 120039'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-057-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
            '                  \"StepID\": 19684'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PRIMARY\",'+
            '            \"FlexSRT\": \"F\",'+
            '            \"ECMFlag\": \"F\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-109-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 2.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        
        Claim = new CSS_Claims__c();
        //CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        Claim.Customer_Name__c='TestCustomer';
        Claim.Account__c=acc.id;
        Claim.Customer_Code__c = '1234';
        Claim.Contact_Last_Name__c = 'T';
        Claim.Address__c = 'T';
        Claim.CSS_Job__c = job1.id;
        Claim.Customer_Contact_Phone__c = null;
        Claim.Email_Address__c = 'RdB@nomail.com';
        Claim.Status__c = 'Draft';
        //Claim.Account__c=acc.Id;
        insert Claim;
        
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F07000130',Solutions__c=solutions.Id, CSS_Claims__c=Claim.id, 
                                                System_Code__c = 'TH', Component_Code__c = 'AC', AccountCode__c ='Krishna 65',
                                                Selected_Component__c = true);
        insert solComp;
        system.debug('solComp'+solComp);
        
        
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        repsrt1.css_claims__c = Claim.id;
        repSRT1.SRT_Order__c=2;
        repairSRT.add(repSRT1);
        
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        repsrt2.css_claims__c = Claim.id;
        repSRT2.SRT_Order__c=411;
        repairSRT.add(repSRT2);
        
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repsrt3.css_claims__c = Claim.id;
        repSRT3.SRT_Order__c=413;
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT4.Name ='Test2';
        repSRT4.Component_Id__c=solComp.id;
        repSRT4.SRT_Type__c='Diag Access';
        repSRT4.Type__c='Diag Access';
        repSRT4.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT4.SRT_ID__c='asd-00';
        repSRT4.SRT_Access_Code__c='A';
        repSRT4.Solution_Number__c= solutions.id;
        repSRT4.Step_Description__c='hgfr';
        repSRT4.Job_Order__c=job1.id;
        repSRT4.SRT_Quantity__c=1;
        repSRT4.Access_Code__c='A';
        repSRT4.isPerformed__c=True;
        repSRT4.SRT_Time__c=1.1;
        repsrt4.css_claims__c = Claim.id;
        repSRT4.Assignment__c='PROGRESSIVE DAMAGE';
        repSRT4.SRT_Order__c=31;
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT5.Name ='Test2';
        repSRT5.Component_Id__c=solComp.id;
        repSRT5.SRT_Type__c='Diagnosis';
        repSRT5.Type__c='Diagnosis';
        repSRT5.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT5.SRT_ID__c='asd-00';
        repSRT5.SRT_Access_Code__c='A';
        repSRT5.Solution_Number__c= solutions.id;
        repSRT5.Step_Description__c='hgfr';
        repSRT5.Job_Order__c=job1.id;
        repSRT5.SRT_Quantity__c=1;
        repSRT5.Access_Code__c='A';
        repSRT5.isPerformed__c=True;
        repSRT5.SRT_Time__c=1.1;
        repSRT5.Assignment__c='PRIMARY';
        repsrt5.css_claims__c = Claim.id;
        repSRT5.SRT_Order__c=41;
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT6.Name ='Test3';
        repSRT6.Component_Id__c=solComp.id;
        repSRT6.SRT_Type__c='Diagnosis';
        repSRT6.Type__c='Diagnosis';
        repSRT6.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT6.SRT_ID__c='asd';
        repSRT6.SRT_Access_Code__c='A';
        repSRT6.Solution_Number__c= solutions.id;
        repSRT6.Step_Description__c='Step Number-00';
        repSRT6.Job_Order__c=job1.id;
        repSRT6.SRT_Quantity__c=1;
        repSRT6.SRT_Order__c=4;
        repSRT6.Access_Code__c='A';
        repSRT6.isPerformed__c=True;
        repSRT6.SRT_Time__c=1.1;
        repSRT6.Assignment__c='PRIMARY';
        repsrt6.css_claims__c = Claim.id;
        repairSRT.add(repSRT6);
        
        CSS_SRT__C repSRT7 = new CSS_SRT__C();
        repSRT7.Name ='Test';
        repSRT7.Component_Id__c=solComp.id;
        repSRT7.SRT_Type__c='Repair';
        repSRT7.Type__c='Repair';
        repSRT7.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT7.SRT_ID__c='asd-00';
        repSRT7.SRT_Access_Code__c='R';
        repSRT7.Solution_Number__c= solutions.id;
        repSRT7.Step_Description__c='hgfr';
        repSRT7.Job_Order__c=job1.id;
        repSRT7.SRT_Quantity__c=1;
        repSRT7.isPerformed__c=True;
        repSRT7.Access_Code__c='R';
        repSRT7.SRT_Time__c=1.1;
        repSRT7.Assignment__c='PRIMARY';
        repSRT7.css_claims__c = Claim.id;
        repSRT7.SRT_Order__c=2;
        repairSRT.add(repSRT7);
        
        CSS_SRT__C repSRT8 = new CSS_SRT__C();
        repSRT8.Name ='Test';
        repSRT8.Component_Id__c=solComp.id;
        repSRT8.SRT_Type__c='Repair';
        repSRT8.Type__c='Repair';
        repSRT8.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT8.SRT_ID__c='asd-00';
        repSRT8.SRT_Access_Code__c='R';
        repSRT8.Solution_Number__c= solutions.id;
        repSRT8.Step_Description__c='hgfr';
        repSRT8.Job_Order__c=job1.id;
        repSRT8.SRT_Quantity__c=1;
        repSRT8.isPerformed__c=True;
        repSRT8.Access_Code__c='R';
        repSRT8.SRT_Time__c=1.1;
        repSRT8.Assignment__c='PROGRESSIVE DAMAGE';
        repSRT8.css_claims__c = Claim.id;
        repSRT8.SRT_Order__c=2;
        repairSRT.add(repSRT8);
        
        CSS_SRT__C repSRT9 = new CSS_SRT__C();
        repSRT9.Name ='Test';
        repSRT9.Component_Id__c=solComp.id;
        repSRT9.SRT_Type__c='Repair';
        repSRT9.Type__c='Repair';
        repSRT9.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT9.SRT_ID__c='asd-00';
        repSRT9.SRT_Access_Code__c='R';
        repSRT9.Solution_Number__c= solutions.id;
        repSRT9.Step_Description__c='hgfr';
        repSRT9.Job_Order__c=job1.id;
        repSRT9.SRT_Quantity__c=1;
        repSRT9.isPerformed__c=True;
        repSRT9.Access_Code__c='R';
        repSRT9.SRT_Time__c=1.1;
        repSRT9.Assignment__c='ALTERNATIVE';
        repSRT9.css_claims__c = Claim.id;
        repSRT9.SRT_Order__c=2;
        repairSRT.add(repSRT9);
        
        CSS_SRT__C repSRT91 = new CSS_SRT__C();
        repSRT91.Name ='Test';
        repSRT91.Component_Id__c=solComp.id;
        repSRT91.SRT_Type__c='Repair';
        repSRT91.Type__c='Repair';
        repSRT91.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT91.SRT_ID__c='asd-00';
        repSRT91.SRT_Access_Code__c='R';
        repSRT91.Solution_Number__c= solutions.id;
        repSRT91.Step_Description__c='hgfr';
        repSRT91.Job_Order__c=job1.id;
        repSRT91.SRT_Quantity__c=1;
        repSRT91.isPerformed__c=True;
        repSRT91.Access_Code__c='R';
        repSRT91.SRT_Time__c=1.1;
        repSRT91.Assignment__c='NOT CLAIMABLE';
        repSRT91.css_claims__c = Claim.id;
        repSRT91.SRT_Order__c=2;
        repairSRT.add(repSRT91);
        
        CSS_SRT__C repSRT92 = new CSS_SRT__C();
        repSRT92.Name ='Test';
        repSRT92.Component_Id__c=solComp.id;
        repSRT92.SRT_Type__c='Repair';
        repSRT92.Type__c='Repair';
        repSRT92.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT92.SRT_ID__c='asd-00';
        repSRT92.SRT_Access_Code__c='A';
        repSRT92.Solution_Number__c= solutions.id;
        repSRT92.Step_Description__c='hgfr';
        repSRT92.Job_Order__c=job1.id;
        repSRT92.SRT_Quantity__c=1;
        repSRT92.isPerformed__c=True;
        repSRT92.Access_Code__c='A';
        repSRT92.SRT_Time__c=1.1;
        repSRT92.Assignment__c='NOT CLAIMABLE';
        repSRT92.css_claims__c = Claim.id;
        repSRT92.SRT_Order__c=2;
        repairSRT.add(repSRT92);
        
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '50';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        CSS_JobEventTemporary__c jET2 = new CSS_JobEventTemporary__c();
        jET2.Attribute1__c = 'NPW';
        jET2.Attribute3__c = '60';
        jET2.Attribute4__c = 'DSBDV5789';
        jET2.Key__c = 'AccountCodes';
        jETList.add(jET2);
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        
        insert jETList;
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        List<string> solCompAdd = new List<string>();
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,claim.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','TYPE','3','7');
      //  CSS_SRT.solCompWrapper comp1 =new CSS_SRT.solCompWrapper(solComp.Solutions__c,job1.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','Campaign','3','7');
        solCompAdd.add(system.JSON.serialize(comp));
      //  solCompAdd.add(system.JSON.serialize(comp1));
        //CSS_SRT.repairSRT(solCompAdd);
        CSS_SRT.repairSRTManualClaim(solCompAdd);
        double data = 120.00;
        String json3 = '{ '+
            
            '\"solID\": \"'+solutions.id+'\", '+
            '\"jobID\": \"'+job1.id+'\", '+
            '\"serviceModel\": \"serviceModel\", '+
            '\"equipID\": \"equipID\", '+
            '\"compID\": \"'+solComp.id+'\", '+
            '\"efc\": \"efc\", '+
            '\"compoName\": \"compoName\" '+
            '\"jobName\": \"jobName\" '+
            '\"claimID\": \"'+data+'\" '+
            
            '}';
        
        
        test.stopTest();
    }
    static testMethod void testRepairSrtmanual(){
        Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Sec_Test());
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        List<string> solCompAdd = new List<string>();
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F07000130',Solutions__c=solutions.Id,Service_Job__c=job1.id, 
                                                System_Code__c = 'TH', Component_Code__c = 'AC', AccountCode__c ='Krishna 65',
                                                Selected_Component__c = true);
        insert solComp;
        
        system.debug('solComp'+solComp);
        Claim = new CSS_Claims__c(CSS_Job__c=job1.Id);
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        repsrt1.css_claims__c = Claim.id;
        repairSRT.add(repSRT1);
        
        CSS_SRT__C repSRT01 = new CSS_SRT__C();
        repSRT01.Name ='Test';
        repSRT01.Component_Id__c=solComp.id;
        repSRT01.SRT_Type__c='Repair';
        repSRT01.Type__c='Repair';
        repSRT01.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT01.SRT_ID__c='asd-01';
        repSRT01.SRT_Access_Code__c='R';
        repSRT01.Solution_Number__c= solutions.id;
        repSRT01.Step_Description__c='hgfr';
        repSRT01.Job_Order__c=job1.id;
        repSRT01.SRT_Quantity__c=1;
        repSRT01.isPerformed__c=True;
        repSRT01.Access_Code__c='R';
        repSRT01.SRT_Time__c=1.1;
        repSRT01.Assignment__c='PRIMARY';
        repSRT01.css_claims__c = Claim.id;
        repairSRT.add(repSRT01);
        
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        repairSRT.add(repSRT2);
        
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT3.Name ='Test20';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diag Access';
        repSRT3.Type__c='Diag Access';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        //repSRT3.CSS_CLaims__C=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        insert repSRT4;
        //repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT3.Name ='Test3';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT6);
        
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        Boolean isRep = false;
        //Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Test());
        
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','TRP','CoveredLaborHrs','CampaignLaborPercentage');
        solCompAdd.add(JSON.Serialize(comp));
        CSS_SRT.repairSRT(solCompAdd);
        double data = 120.00;
        String json = '{ '+
            
            '\"solID\": \"'+solutions.id+'\", '+
            '\"jobID\": \"'+job1.id+'\", '+
            '\"serviceModel\": \"serviceModel\", '+
            '\"equipID\": \"equipID\", '+
            '\"compID\": \"'+solComp.id+'\", '+
            '\"efc\": \"efc\", '+
            '\"compoName\": \"compoName\" '+
            '\"jobName\": \"jobName\" '+
            '\"claimID\": \"'+data+'\" '+
            
            '}';
        
        //Test.setMock(HttpCalloutMock.class, new CSS_MockRepair_SRT_Test());
        //css_srt.repairSRTManualClaim(solCompAdd);
        test.stopTest();
    }
    static testMethod void testRepairSrtmanualcase1(){
        Test.setMock(HttpCalloutMock.class, new CSS_MockRepair_SRT_Test());
        List<string> solCompAdd = new List<string>();
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.Account__c =acc.id;
        clams.ESN__c='53426754';
        clams.CSS_Job__c=job1.Id;
        clams.Actual_Technician_Time__c=2.0;
        insert clams;
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
         solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F07000130',Solutions__c=solutions.Id,Service_Job__c=job1.id, 
                                                System_Code__c = 'TH', Component_Code__c = 'AC', AccountCode__c ='Krishna 65',
                                                Selected_Component__c = true);
        insert solComp;
        system.debug('solComp'+solComp);
        
        
        
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        repsrt1.css_claims__c = Clams.id;
        repairSRT.add(repSRT1);
        
        CSS_SRT__C repSRT01 = new CSS_SRT__C();
        repSRT01.Name ='Test';
        repSRT01.Component_Id__c=solComp.id;
        repSRT01.SRT_Type__c='Repair';
        repSRT01.Type__c='Repair';
        repSRT01.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT01.SRT_ID__c='asd-01';
        repSRT01.SRT_Access_Code__c='R';
        repSRT01.Solution_Number__c= solutions.id;
        repSRT01.Step_Description__c='hgfr';
        repSRT01.Job_Order__c=job1.id;
        repSRT01.SRT_Quantity__c=1;
        repSRT01.isPerformed__c=True;
        repSRT01.Access_Code__c='R';
        repSRT01.SRT_Time__c=1.1;
        repSRT01.Assignment__c='PRIMARY';
        repairSRT.add(repSRT01);
        
        CSS_SRT__C repSRT001 = new CSS_SRT__C();
        repSRT001.Name ='Test';
        repSRT001.Component_Id__c=solComp.id;
        repSRT001.SRT_Type__c='Repair';
        repSRT001.Type__c='Repair';
        repSRT001.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT001.SRT_ID__c='asd-01';
        repSRT001.SRT_Access_Code__c='R';
        repSRT001.Solution_Number__c= solutions.id;
        repSRT001.Step_Description__c='hgfr';
        repSRT001.Job_Order__c=job1.id;
        repSRT001.SRT_Quantity__c=1;
        repSRT001.isPerformed__c=True;
        repSRT001.Access_Code__c='R';
        repSRT001.SRT_Time__c=1.1;
        repSRT001.Assignment__c='ALTERNATIVE';
        repairSRT.add(repSRT001);
        
        CSS_SRT__C repSRT901 = new CSS_SRT__C();
        repSRT901.Name ='Test';
        repSRT901.Component_Id__c=solComp.id;
        repSRT901.SRT_Type__c='Repair';
        repSRT901.Type__c='Repair';
        repSRT901.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT901.SRT_ID__c='asd-01';
        repSRT901.SRT_Access_Code__c='R';
        repSRT901.Solution_Number__c= solutions.id;
        repSRT901.Step_Description__c='hgfr';
        repSRT901.Job_Order__c=job1.id;
        repSRT901.SRT_Quantity__c=1;
        repSRT901.isPerformed__c=True;
        repSRT901.Access_Code__c='R';
        repSRT901.SRT_Time__c=1.1;
        repSRT901.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT901);
        
        
        
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        repairSRT.add(repSRT2);
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diag Access';
        repSRT3.Type__c='Diag Access';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        //repSRT3.CSS_CLaims__C=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='Step Number-00';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT3.Name ='Test3';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='Step Number-00';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT6);
        
        CSS_SRT__C repSRT7 = new CSS_SRT__C();
        repSRT7.Name ='Test2';
        repSRT7.Component_Id__c=solComp.id;
        repSRT7.SRT_Type__c='Repair';
        repSRT7.Type__c='Repair';
        repSRT7.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT7.SRT_ID__c='asd-00';
        repSRT7.SRT_Access_Code__c='A';
        repSRT7.Solution_Number__c= solutions.id;
        repSRT7.Step_Description__c='hgfr';
        repSRT7.Job_Order__c=job1.id;
        repSRT7.CSS_Claims__C=clams.id;
        repSRT7.SRT_Quantity__c=1;
        repSRT7.Access_Code__c='A';
        repSRT7.isPerformed__c=True;
        repSRT7.SRT_Time__c=1.1;
        repSRT7.Assignment__c='PROGRESSIVE DAMAGE';
        //repairSRT.add(repSRT7);
        insert repSRT7;
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRTKal>>>>'+repSRT7);
        system.debug('repSRT1>>>>'+repairSRT);
        
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        Boolean isRep = false;
        //Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Test());
        
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.css_claims__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','Campaign','CoveredLaborHrs','CampaignLaborPercentage');
        solCompAdd.add(JSON.Serialize(comp));
        CSS_SRT.repairSRT(solCompAdd);
        double data = 120.00;
        String json = '{ '+
            
            '\"solID\": \"'+solutions.id+'\", '+
            '\"jobID\": \"'+job1.id+'\", '+
            '\"serviceModel\": \"serviceModel\", '+
            '\"equipID\": \"equipID\", '+
            '\"compID\": \"'+solComp.id+'\", '+
            '\"efc\": \"efc\", '+
            '\"compoName\": \"compoName\" '+
            '\"jobName\": \"jobName\" '+
            '\"claimID\": \"'+data+'\" '+
            
            '}';
        List<String> lst = new List<String>();
        lst.add(json);
        //css_srt.repairSRTManualClaim(solCompAdd);
        test.stopTest();
    }
    static testMethod void testRepairSrtdiag(){
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        
        css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Solutions__c=solutions.Id,Service_Job__c=job1.id);
        insert solComp;
        system.debug('solComp'+solComp);
        Claim = new CSS_Claims__c(CSS_Job__c=job1.Id,SP_INSHOP_LABOR_RATE__c='20',Accesscode__c='ABC');
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='00-724-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Order__c=50;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        repsrt1.css_claims__c = Claim.id;
        repairSRT.add(repSRT1);
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='00-724-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        repairSRT.add(repSRT2);
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='00-724-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT4.Name ='Test2';
        repSRT4.Component_Id__c=solComp.id;
        repSRT4.SRT_Type__c='Diag Access';
        repSRT4.Type__c='Diag Access';
        repSRT4.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT4.SRT_ID__c='00-724-00';
        repSRT4.SRT_Access_Code__c='A';
        repSRT4.Solution_Number__c= solutions.id;
        repSRT4.Step_Description__c='hgfr';
        repSRT4.Job_Order__c=job1.id;
        repSRT4.SRT_Quantity__c=1;
        repSRT4.Access_Code__c='A';
        repSRT4.isPerformed__c=True;
        repSRT4.SRT_Time__c=1.1;
        
        repSRT4.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT4);
        CSS_SRT__C repSRT41 = new CSS_SRT__C();
        repSRT41.Name ='Test2';
        repSRT41.Component_Id__c=solComp.id;
        repSRT41.SRT_Type__c='Diag Access';
        repSRT41.Type__c='Diag Access';
        repSRT41.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT41.SRT_ID__c='00-724';
        repSRT41.SRT_Access_Code__c='A';
        repSRT41.Solution_Number__c= solutions.id;
        repSRT41.Step_Description__c='hgfr';
        repSRT41.Job_Order__c=job1.id;
        repSRT41.SRT_Quantity__c=1;
        repSRT41.Access_Code__c='A';
        repSRT41.isPerformed__c=True;
        repSRT41.SRT_Time__c=1.1;
        
        repSRT41.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT41);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT5.Name ='Test2';
        repSRT5.Component_Id__c=solComp.id;
        repSRT5.SRT_Type__c='Diagnosis';
        repSRT5.Type__c='Diagnosis';
        repSRT5.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT5.SRT_ID__c='00-724-00';
        repSRT5.SRT_Access_Code__c='A';
        repSRT5.Solution_Number__c= solutions.id;
        repSRT5.Step_Description__c='hgfr';
        repSRT5.Job_Order__c=job1.id;
        repSRT5.SRT_Quantity__c=1;
        repSRT5.Access_Code__c='A';
        repSRT5.isPerformed__c=True;
        repSRT5.SRT_Time__c=1.1;
        repSRT5.Assignment__c='PRIMARY';
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT6.Name ='Test3';
        repSRT6.Component_Id__c=solComp.id;
        repSRT6.SRT_Type__c='Diagnosis';
        repSRT6.Type__c='Diagnosis';
        repSRT6.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT6.SRT_ID__c='00-724';
        repSRT6.SRT_Access_Code__c='A';
        repSRT6.Solution_Number__c= solutions.id;
        repSRT6.Step_Description__c='Step Number-00';
        repSRT6.Job_Order__c=job1.id;
        repSRT6.SRT_Quantity__c=1;
        repSRT6.Access_Code__c='A';
        repSRT6.isPerformed__c=True;
        repSRT6.SRT_Time__c=1.1;
        repSRT6.Assignment__c='PRIMARY';
        repairSRT.add(repSRT6);
        CSS_SRT__C repSRT67 = new CSS_SRT__C();
        repSRT67.Name ='Test323';
        repSRT67.Component_Id__c=solComp.id;
        repSRT67.SRT_Type__c='Diagnosis';
        repSRT67.Type__c='Diagnosis';
        repSRT67.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT67.SRT_ID__c='00-724';
        repSRT67.SRT_Access_Code__c='A';
        repSRT67.Solution_Number__c= solutions.id;
        repSRT67.Step_Description__c='';
        repSRT67.Job_Order__c=job1.id;
        repSRT67.SRT_Quantity__c=1;
        repSRT67.Access_Code__c='A';
        repSRT67.isPerformed__c=True;
        repSRT67.SRT_Time__c=1.1;
        repSRT67.Assignment__c='PRIMARY';
        repairSRT.add(repSRT67);     
        insert repairSRT;
        
        
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        test.startTest();
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        
        String json1 ='{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"UNLISTED\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
            '                  \"StepID\": 120039'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-057-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
            '                  \"StepID\": 19684'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"PRIMARY\",'+
            '            \"FlexSRT\": \"F\",'+
            '            \"ECMFlag\": \"F\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-109-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 2.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        List<string> solCompAdd = new List<string>();
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','ATDCS','40','20');
        CSS_SRT.solCompWrapper comp1 =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','Campaign','3','7');
        solCompAdd.add(system.JSON.serialize(comp));
        solCompAdd.add(system.JSON.serialize(comp1));
        
        CSS_SRT.repairSRT(solCompAdd);
        test.stopTest();
        
        
        List<css_srt__c> srtlst = new List<css_srt__c>();
        
        CSS_SRT__C repSRT68 = new CSS_SRT__C();
        repSRT68.Job_Order__c=job1.id;
        repSRT68.type__c='Repair';
        repSRT68.SRT_Access_Code__c='5577';
        repSRT68.SRT_ID__c='10-117-12';
        srtlst.add(repSRT68);
        insert repSRT68;
        CSS_SRT.repairSRT(solCompAdd);
    }
    static testMethod void testRepairSrtdiag1(){
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        
        css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Solutions__c=solutions.Id,Service_Job__c=job1.id);
        insert solComp;
        system.debug('solComp'+solComp);
        Claim = new CSS_Claims__c(CSS_Job__c=job1.Id,SP_INSHOP_LABOR_RATE__c='20',Accesscode__c='ABC');
        
        
        test.startTest();
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        
        String json1 ='{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"UNLISTED\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
            '                  \"StepID\": 120039'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-057-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
            '                  \"StepID\": 19684'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F19000990\",'+
            '            \"Assignment\": \"PRIMARY\",'+
            '            \"FlexSRT\": \"F\",'+
            '            \"ECMFlag\": \"F\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-109-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 2.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        List<string> solCompAdd = new List<string>();
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','ATDCS','40','20');
        CSS_SRT.solCompWrapper comp1 =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','Campaign','3','7');
        solCompAdd.add(system.JSON.serialize(comp));
        solCompAdd.add(system.JSON.serialize(comp1));
        
        CSS_SRT.repairSRT(solCompAdd);
        test.stopTest();
    }
    static testMethod void testRepairSrtjob(){
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        String json1 ='{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"UNLISTED\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
            '                  \"StepID\": 120039'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-057-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
            '                  \"StepID\": 19684'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PRIMARY\",'+
            '            \"FlexSRT\": \"F\",'+
            '            \"ECMFlag\": \"F\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-109-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 2.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        //css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F07000130',Solutions__c=solutions.Id,Service_Job__c=job1.id, 
                                                System_Code__c = 'TH', Component_Code__c = 'AC', AccountCode__c ='Krishna 65',
                                                Selected_Component__c = true);
        insert solComp;
        system.debug('solComp'+solComp);
        /* Claim = new CSS_Claims__c();
CSS_Claims__c testclaimsRec = new CSS_Claims__c();
Claim.Customer_Name__c='TestCustomer';
Claim.Account__c=acc.id;
Claim.Customer_Code__c = '1234';
Claim.Contact_Last_Name__c = 'T';
Claim.Address__c = 'T';
Claim.CSS_Job__c = job1.id;
Claim.Customer_Contact_Phone__c = null;
Claim.Email_Address__c = 'RdB@nomail.com';
Claim.Status__c = 'Draft';
Claim.Account__c=acc.Id;
insert Claim;*/
        
        
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        //repsrt1.css_claims__c = Claim.id;
        repSRT1.SRT_Order__c=2;
        repairSRT.add(repSRT1);
        
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        //repsrt2.css_claims__c = Claim.id;
        repSRT2.SRT_Order__c=411;
        repairSRT.add(repSRT2);
        
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        // repsrt3.css_claims__c = Claim.id;
        repSRT3.SRT_Order__c=413;
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT4.Name ='Test2';
        repSRT4.Component_Id__c=solComp.id;
        repSRT4.SRT_Type__c='Diag Access';
        repSRT4.Type__c='Diag Access';
        repSRT4.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT4.SRT_ID__c='asd-00';
        repSRT4.SRT_Access_Code__c='A';
        repSRT4.Solution_Number__c= solutions.id;
        repSRT4.Step_Description__c='hgfr';
        repSRT4.Job_Order__c=job1.id;
        repSRT4.SRT_Quantity__c=1;
        repSRT4.Access_Code__c='A';
        repSRT4.isPerformed__c=True;
        repSRT4.SRT_Time__c=1.1;
        // repsrt4.css_claims__c = Claim.id;
        repSRT4.Assignment__c='PROGRESSIVE DAMAGE';
        repSRT4.SRT_Order__c=31;
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT5.Name ='Test2';
        repSRT5.Component_Id__c=solComp.id;
        repSRT5.SRT_Type__c='Diagnosis';
        repSRT5.Type__c='Diagnosis';
        repSRT5.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT5.SRT_ID__c='asd-00';
        repSRT5.SRT_Access_Code__c='A';
        repSRT5.Solution_Number__c= solutions.id;
        repSRT5.Step_Description__c='hgfr';
        repSRT5.Job_Order__c=job1.id;
        repSRT5.SRT_Quantity__c=1;
        repSRT5.Access_Code__c='A';
        repSRT5.isPerformed__c=True;
        repSRT5.SRT_Time__c=1.1;
        repSRT5.Assignment__c='PRIMARY';
        // repsrt5.css_claims__c = Claim.id;
        repSRT5.SRT_Order__c=41;
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT6.Name ='Test3';
        repSRT6.Component_Id__c=solComp.id;
        repSRT6.SRT_Type__c='Diagnosis';
        repSRT6.Type__c='Diagnosis';
        repSRT6.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT6.SRT_ID__c='asd';
        repSRT6.SRT_Access_Code__c='A';
        repSRT6.Solution_Number__c= solutions.id;
        repSRT6.Step_Description__c='Step Number-00';
        repSRT6.Job_Order__c=job1.id;
        repSRT6.SRT_Quantity__c=1;
        repSRT6.SRT_Order__c=4;
        repSRT6.Access_Code__c='A';
        repSRT6.isPerformed__c=True;
        repSRT6.SRT_Time__c=1.1;
        repSRT6.Assignment__c='PRIMARY';
        //repsrt6.css_claims__c = Claim.id;
        repairSRT.add(repSRT6);
        
        CSS_SRT__C repSRT7 = new CSS_SRT__C();
        repSRT7.Name ='Test3';
        repSRT7.Component_Id__c=solComp.id;
        repSRT7.SRT_Type__c='Repair';
        repSRT7.Type__c='Repair';
        repSRT7.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT7.SRT_ID__c='asd';
        repSRT7.SRT_Access_Code__c='R';
        repSRT7.Solution_Number__c= solutions.id;
        repSRT7.Step_Description__c='Step Number-00';
        repSRT7.Job_Order__c=job1.id;
        repSRT7.SRT_Quantity__c=1;
        repSRT7.SRT_Order__c=4;
        repSRT7.Access_Code__c='R';
        repSRT7.isPerformed__c=True;
        repSRT7.SRT_Time__c=1.1;
        repSRT7.Assignment__c='PRIMARY';
        //repSRT7.css_claims__c = Claim.id;
        repairSRT.add(repSRT7);
        
        CSS_SRT__C repSRT8 = new CSS_SRT__C();
        repSRT8.Name ='Test3';
        repSRT8.Component_Id__c=solComp.id;
        repSRT8.SRT_Type__c='Repair';
        repSRT8.Type__c='Repair';
        repSRT8.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT8.SRT_ID__c='asd';
        repSRT8.SRT_Access_Code__c='R';
        repSRT8.Solution_Number__c= solutions.id;
        repSRT8.Step_Description__c='Step Number-00';
        repSRT8.Job_Order__c=job1.id;
        repSRT8.SRT_Quantity__c=1;
        repSRT8.SRT_Order__c=4;
        repSRT8.Access_Code__c='R';
        repSRT8.isPerformed__c=True;
        repSRT8.SRT_Time__c=1.1;
        repSRT8.Assignment__c='ALTERNATIVE';
        //repSRT8.css_claims__c = Claim.id;
        repairSRT.add(repSRT8);
        
        CSS_SRT__C repSRT9 = new CSS_SRT__C();
        repSRT9.Name ='Test3';
        repSRT9.Component_Id__c=solComp.id;
        repSRT9.SRT_Type__c='Repair';
        repSRT9.Type__c='Repair';
        repSRT9.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT9.SRT_ID__c='asd';
        repSRT9.SRT_Access_Code__c='R';
        repSRT9.Solution_Number__c= solutions.id;
        repSRT9.Step_Description__c='Step Number-00';
        repSRT9.Job_Order__c=job1.id;
        repSRT9.SRT_Quantity__c=1;
        repSRT9.SRT_Order__c=4;
        repSRT9.Access_Code__c='R';
        repSRT9.isPerformed__c=True;
        repSRT9.SRT_Time__c=1.1;
        repSRT9.Assignment__c='PROGRESSIVE DAMAGE';
        //repSRT9.css_claims__c = Claim.id;
        repairSRT.add(repSRT9);
        
        CSS_SRT__C repSRT91 = new CSS_SRT__C();
        repSRT91.Name ='Test3';
        repSRT91.Component_Id__c=solComp.id;
        repSRT91.SRT_Type__c='Repair';
        repSRT91.Type__c='Repair';
        repSRT91.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT91.SRT_ID__c='asd';
        repSRT91.SRT_Access_Code__c='R';
        repSRT91.Solution_Number__c= solutions.id;
        repSRT91.Step_Description__c='Step Number-00';
        repSRT91.Job_Order__c=job1.id;
        repSRT91.SRT_Quantity__c=1;
        repSRT91.SRT_Order__c=4;
        repSRT91.Access_Code__c='R';
        repSRT91.isPerformed__c=True;
        repSRT91.SRT_Time__c=1.1;
        repSRT91.Assignment__c='NOT CLAIMABLE';
        //repSRT91.css_claims__c = Claim.id;
        repairSRT.add(repSRT91);
        
        CSS_SRT__C repSRT92 = new CSS_SRT__C();
        repSRT92.Name ='Test3';
        repSRT92.Component_Id__c=solComp.id;
        repSRT92.SRT_Type__c='Repair';
        repSRT92.Type__c='Repair';
        repSRT92.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT92.SRT_ID__c='asd';
        repSRT92.SRT_Access_Code__c='A';
        repSRT92.Solution_Number__c= solutions.id;
        repSRT92.Step_Description__c='Step Number-00';
        repSRT92.Job_Order__c=job1.id;
        repSRT92.SRT_Quantity__c=1;
        repSRT92.SRT_Order__c=4;
        repSRT92.Access_Code__c='A';
        repSRT92.isPerformed__c=True;
        repSRT92.SRT_Time__c=1.1;
        repSRT92.Assignment__c='NOT CLAIMABLE';
        //repSRT92.css_claims__c = Claim.id;
        repairSRT.add(repSRT92);
        
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '50';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        CSS_JobEventTemporary__c jET2 = new CSS_JobEventTemporary__c();
        jET2.Attribute1__c = 'NPW';
        jET2.Attribute3__c = '60';
        jET2.Attribute4__c = 'DSBDV5789';
        jET2.Key__c = 'AccountCodes';
        jETList.add(jET2);
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        
        insert jETList;
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        List<string> solCompAdd = new List<string>();
        //CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,claim.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','TYPE','3','7');
        CSS_SRT.solCompWrapper comp1 =new CSS_SRT.solCompWrapper(solComp.Solutions__c,job1.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','Campaign','3','7');
        // solCompAdd.add(system.JSON.serialize(comp));
        solCompAdd.add(system.JSON.serialize(comp1));
        CSS_SRT.repairSRT(solCompAdd);
       // CSS_SRT.repairSRTManualClaim(solCompAdd);
        double data = 120.00;
        String json3 = '{ '+
            
            '\"solID\": \"'+solutions.id+'\", '+
            '\"jobID\": \"'+job1.id+'\", '+
            '\"serviceModel\": \"serviceModel\", '+
            '\"equipID\": \"equipID\", '+
            '\"compID\": \"'+solComp.id+'\", '+
            '\"efc\": \"efc\", '+
            '\"compoName\": \"compoName\" '+
            '\"jobName\": \"jobName\" '+
            '\"claimID\": \"'+data+'\" '+
            
            '}';
        
        
        test.stopTest();
    }
    static testMethod void testRepairSrtjob222(){
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        String json1 ='{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"UNLISTED\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
            '                  \"StepID\": 120039'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-057-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
            '                  \"StepID\": 19684'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"F\",'+
            '            \"ECMFlag\": \"F\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-109-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 2.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        //css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F07000130',Solutions__c=solutions.Id,Service_Job__c=job1.id, 
                                                System_Code__c = 'TH', Component_Code__c = 'AC', AccountCode__c ='Krishna 65',
                                                Selected_Component__c = true);
        insert solComp;
        system.debug('solComp'+solComp);
        
        
        
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='ALTERNATIVE';
        //repsrt1.css_claims__c = Claim.id;
        repSRT1.SRT_Order__c=2;
        repairSRT.add(repSRT1);
        
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        //repsrt2.css_claims__c = Claim.id;
        repSRT2.SRT_Order__c=411;
        repairSRT.add(repSRT2);
        
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        // repsrt3.css_claims__c = Claim.id;
        repSRT3.SRT_Order__c=413;
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT4.Name ='Test2';
        repSRT4.Component_Id__c=solComp.id;
        repSRT4.SRT_Type__c='Diag Access';
        repSRT4.Type__c='Diag Access';
        repSRT4.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT4.SRT_ID__c='asd-00';
        repSRT4.SRT_Access_Code__c='A';
        repSRT4.Solution_Number__c= solutions.id;
        repSRT4.Step_Description__c='hgfr';
        repSRT4.Job_Order__c=job1.id;
        repSRT4.SRT_Quantity__c=1;
        repSRT4.Access_Code__c='A';
        repSRT4.isPerformed__c=True;
        repSRT4.SRT_Time__c=1.1;
        // repsrt4.css_claims__c = Claim.id;
        repSRT4.Assignment__c='PROGRESSIVE DAMAGE';
        repSRT4.SRT_Order__c=31;
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT5.Name ='Test2';
        repSRT5.Component_Id__c=solComp.id;
        repSRT5.SRT_Type__c='Diagnosis';
        repSRT5.Type__c='Diagnosis';
        repSRT5.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT5.SRT_ID__c='asd-00';
        repSRT5.SRT_Access_Code__c='A';
        repSRT5.Solution_Number__c= solutions.id;
        repSRT5.Step_Description__c='hgfr';
        repSRT5.Job_Order__c=job1.id;
        repSRT5.SRT_Quantity__c=1;
        repSRT5.Access_Code__c='A';
        repSRT5.isPerformed__c=True;
        repSRT5.SRT_Time__c=1.1;
        repSRT5.Assignment__c='ALTERNATIVE';
        // repsrt5.css_claims__c = Claim.id;
        repSRT5.SRT_Order__c=41;
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT6.Name ='Test3';
        repSRT6.Component_Id__c=solComp.id;
        repSRT6.SRT_Type__c='Diagnosis';
        repSRT6.Type__c='Diagnosis';
        repSRT6.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT6.SRT_ID__c='asd';
        repSRT6.SRT_Access_Code__c='A';
        repSRT6.Solution_Number__c= solutions.id;
        repSRT6.Step_Description__c='Step Number-00';
        repSRT6.Job_Order__c=job1.id;
        repSRT6.SRT_Quantity__c=1;
        repSRT6.SRT_Order__c=4;
        repSRT6.Access_Code__c='A';
        repSRT6.isPerformed__c=True;
        repSRT6.SRT_Time__c=1.1;
        repSRT6.Assignment__c='PROGRESSIVE DAMAGE';
        //repsrt6.css_claims__c = Claim.id;
        repairSRT.add(repSRT6);
        
        CSS_SRT__C repSRT7 = new CSS_SRT__C();
        repSRT7.Name ='Test3';
        repSRT7.Component_Id__c=solComp.id;
        repSRT7.SRT_Type__c='Repair';
        repSRT7.Type__c='Repair';
        repSRT7.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT7.SRT_ID__c='asd';
        repSRT7.SRT_Access_Code__c='R';
        repSRT7.Solution_Number__c= solutions.id;
        repSRT7.Step_Description__c='Step Number-00';
        repSRT7.Job_Order__c=job1.id;
        repSRT7.SRT_Quantity__c=1;
        repSRT7.SRT_Order__c=4;
        repSRT7.Access_Code__c='R';
        repSRT7.isPerformed__c=True;
        repSRT7.SRT_Time__c=1.1;
        repSRT7.Assignment__c='PROGRESSIVE DAMAGE';
        //repSRT7.css_claims__c = Claim.id;
        repairSRT.add(repSRT7);
        
        CSS_SRT__C repSRT8 = new CSS_SRT__C();
        repSRT8.Name ='Test3';
        repSRT8.Component_Id__c=solComp.id;
        repSRT8.SRT_Type__c='Repair';
        repSRT8.Type__c='Repair';
        repSRT8.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT8.SRT_ID__c='asd';
        repSRT8.SRT_Access_Code__c='R';
        repSRT8.Solution_Number__c= solutions.id;
        repSRT8.Step_Description__c='Step Number-00';
        repSRT8.Job_Order__c=job1.id;
        repSRT8.SRT_Quantity__c=1;
        repSRT8.SRT_Order__c=4;
        repSRT8.Access_Code__c='R';
        repSRT8.isPerformed__c=True;
        repSRT8.SRT_Time__c=1.1;
        repSRT8.Assignment__c='ALTERNATIVE';
        //repSRT8.css_claims__c = Claim.id;
        repairSRT.add(repSRT8);
        
        CSS_SRT__C repSRT9 = new CSS_SRT__C();
        repSRT9.Name ='Test3';
        repSRT9.Component_Id__c=solComp.id;
        repSRT9.SRT_Type__c='Repair';
        repSRT9.Type__c='Repair';
        repSRT9.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT9.SRT_ID__c='asd';
        repSRT9.SRT_Access_Code__c='R';
        repSRT9.Solution_Number__c= solutions.id;
        repSRT9.Step_Description__c='Step Number-00';
        repSRT9.Job_Order__c=job1.id;
        repSRT9.SRT_Quantity__c=1;
        repSRT9.SRT_Order__c=4;
        repSRT9.Access_Code__c='R';
        repSRT9.isPerformed__c=True;
        repSRT9.SRT_Time__c=1.1;
        repSRT9.Assignment__c='PROGRESSIVE DAMAGE';
        //repSRT9.css_claims__c = Claim.id;
        repairSRT.add(repSRT9);
        
        CSS_SRT__C repSRT91 = new CSS_SRT__C();
        repSRT91.Name ='Test3';
        repSRT91.Component_Id__c=solComp.id;
        repSRT91.SRT_Type__c='Repair';
        repSRT91.Type__c='Repair';
        repSRT91.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT91.SRT_ID__c='asd';
        repSRT91.SRT_Access_Code__c='R';
        repSRT91.Solution_Number__c= solutions.id;
        repSRT91.Step_Description__c='Step Number-00';
        repSRT91.Job_Order__c=job1.id;
        repSRT91.SRT_Quantity__c=1;
        repSRT91.SRT_Order__c=4;
        repSRT91.Access_Code__c='R';
        repSRT91.isPerformed__c=True;
        repSRT91.SRT_Time__c=1.1;
        repSRT91.Assignment__c='NOT CLAIMABLE';
        //repSRT91.css_claims__c = Claim.id;
        repairSRT.add(repSRT91);
        
        CSS_SRT__C repSRT92 = new CSS_SRT__C();
        repSRT92.Name ='Test3';
        repSRT92.Component_Id__c=solComp.id;
        repSRT92.SRT_Type__c='Repair';
        repSRT92.Type__c='Repair';
        repSRT92.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT92.SRT_ID__c='asd';
        repSRT92.SRT_Access_Code__c='A';
        repSRT92.Solution_Number__c= solutions.id;
        repSRT92.Step_Description__c='Step Number-00';
        repSRT92.Job_Order__c=job1.id;
        repSRT92.SRT_Quantity__c=1;
        repSRT92.SRT_Order__c=4;
        repSRT92.Access_Code__c='A';
        repSRT92.isPerformed__c=True;
        repSRT92.SRT_Time__c=1.1;
        repSRT92.Assignment__c='NOT CLAIMABLE';
        //repSRT92.css_claims__c = Claim.id;
        repairSRT.add(repSRT92);
        
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '50';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        CSS_JobEventTemporary__c jET2 = new CSS_JobEventTemporary__c();
        jET2.Attribute1__c = 'NPW';
        jET2.Attribute3__c = '60';
        jET2.Attribute4__c = 'DSBDV5789';
        jET2.Key__c = 'AccountCodes';
        jETList.add(jET2);
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        
        insert jETList;
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        List<string> solCompAdd = new List<string>();
        //CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,claim.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','TYPE','3','7');
        CSS_SRT.solCompWrapper comp1 =new CSS_SRT.solCompWrapper(solComp.Solutions__c,job1.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','Campaign','3','7');
        // solCompAdd.add(system.JSON.serialize(comp));
        solCompAdd.add(system.JSON.serialize(comp1));
        CSS_SRT.repairSRT(solCompAdd);
       // CSS_SRT.repairSRTManualClaim(solCompAdd);
        double data = 120.00;
        String json3 = '{ '+
            
            '\"solID\": \"'+solutions.id+'\", '+
            '\"jobID\": \"'+job1.id+'\", '+
            '\"serviceModel\": \"serviceModel\", '+
            '\"equipID\": \"equipID\", '+
            '\"compID\": \"'+solComp.id+'\", '+
            '\"efc\": \"efc\", '+
            '\"compoName\": \"compoName\" '+
            '\"jobName\": \"jobName\" '+
            '\"claimID\": \"'+data+'\" '+
            
            '}';
        
        
        test.stopTest();
    }
    static testMethod void testRepairSrtjob333(){
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        String json1 ='{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"UNLISTED\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
            '                  \"StepID\": 120039'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-057-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
            '                  \"StepID\": 19684'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"F\",'+
            '            \"ECMFlag\": \"F\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-109-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 2.2,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        //css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F07000130',Solutions__c=solutions.Id,Service_Job__c=job1.id, 
                                                System_Code__c = 'TH', Component_Code__c = 'AC', AccountCode__c ='Krishna 65',
                                                Selected_Component__c = true);
        insert solComp;
        system.debug('solComp'+solComp);
        /* Claim = new CSS_Claims__c();
CSS_Claims__c testclaimsRec = new CSS_Claims__c();
Claim.Customer_Name__c='TestCustomer';
Claim.Account__c=acc.id;
Claim.Customer_Code__c = '1234';
Claim.Contact_Last_Name__c = 'T';
Claim.Address__c = 'T';
Claim.CSS_Job__c = job1.id;
Claim.Customer_Contact_Phone__c = null;
Claim.Email_Address__c = 'RdB@nomail.com';
Claim.Status__c = 'Draft';
Claim.Account__c=acc.Id;
insert Claim;*/
        
        
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PROGRESSIVE DAMAGE';
        //repsrt1.css_claims__c = Claim.id;
        repSRT1.SRT_Order__c=2;
        repairSRT.add(repSRT1);
        
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        //repsrt2.css_claims__c = Claim.id;
        repSRT2.SRT_Order__c=411;
        repairSRT.add(repSRT2);
        
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        // repsrt3.css_claims__c = Claim.id;
        repSRT3.SRT_Order__c=413;
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT4.Name ='Test2';
        repSRT4.Component_Id__c=solComp.id;
        repSRT4.SRT_Type__c='Diag Access';
        repSRT4.Type__c='Diag Access';
        repSRT4.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT4.SRT_ID__c='asd-00';
        repSRT4.SRT_Access_Code__c='A';
        repSRT4.Solution_Number__c= solutions.id;
        repSRT4.Step_Description__c='hgfr';
        repSRT4.Job_Order__c=job1.id;
        repSRT4.SRT_Quantity__c=1;
        repSRT4.Access_Code__c='A';
        repSRT4.isPerformed__c=True;
        repSRT4.SRT_Time__c=1.1;
        // repsrt4.css_claims__c = Claim.id;
        repSRT4.Assignment__c='PROGRESSIVE DAMAGE';
        repSRT4.SRT_Order__c=31;
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT5.Name ='Test2';
        repSRT5.Component_Id__c=solComp.id;
        repSRT5.SRT_Type__c='Diagnosis';
        repSRT5.Type__c='Diagnosis';
        repSRT5.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT5.SRT_ID__c='asd-00';
        repSRT5.SRT_Access_Code__c='A';
        repSRT5.Solution_Number__c= solutions.id;
        repSRT5.Step_Description__c='hgfr';
        repSRT5.Job_Order__c=job1.id;
        repSRT5.SRT_Quantity__c=1;
        repSRT5.Access_Code__c='A';
        repSRT5.isPerformed__c=True;
        repSRT5.SRT_Time__c=1.1;
        repSRT5.Assignment__c='PROGRESSIVE DAMAGE';
        // repsrt5.css_claims__c = Claim.id;
        repSRT5.SRT_Order__c=41;
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT6.Name ='Test3';
        repSRT6.Component_Id__c=solComp.id;
        repSRT6.SRT_Type__c='Diagnosis';
        repSRT6.Type__c='Diagnosis';
        repSRT6.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT6.SRT_ID__c='asd';
        repSRT6.SRT_Access_Code__c='A';
        repSRT6.Solution_Number__c= solutions.id;
        repSRT6.Step_Description__c='Step Number-00';
        repSRT6.Job_Order__c=job1.id;
        repSRT6.SRT_Quantity__c=1;
        repSRT6.SRT_Order__c=4;
        repSRT6.Access_Code__c='A';
        repSRT6.isPerformed__c=True;
        repSRT6.SRT_Time__c=1.1;
        repSRT6.Assignment__c='PROGRESSIVE DAMAGE';
        //repsrt6.css_claims__c = Claim.id;
        repairSRT.add(repSRT6);
        
        CSS_SRT__C repSRT7 = new CSS_SRT__C();
        repSRT7.Name ='Test3';
        repSRT7.Component_Id__c=solComp.id;
        repSRT7.SRT_Type__c='Repair';
        repSRT7.Type__c='Repair';
        repSRT7.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT7.SRT_ID__c='asd';
        repSRT7.SRT_Access_Code__c='R';
        repSRT7.Solution_Number__c= solutions.id;
        repSRT7.Step_Description__c='Step Number-00';
        repSRT7.Job_Order__c=job1.id;
        repSRT7.SRT_Quantity__c=1;
        repSRT7.SRT_Order__c=4;
        repSRT7.Access_Code__c='R';
        repSRT7.isPerformed__c=True;
        repSRT7.SRT_Time__c=1.1;
        repSRT7.Assignment__c='PROGRESSIVE DAMAGE';
        //repSRT7.css_claims__c = Claim.id;
        repairSRT.add(repSRT7);
        
        CSS_SRT__C repSRT8 = new CSS_SRT__C();
        repSRT8.Name ='Test3';
        repSRT8.Component_Id__c=solComp.id;
        repSRT8.SRT_Type__c='Repair';
        repSRT8.Type__c='Repair';
        repSRT8.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT8.SRT_ID__c='asd';
        repSRT8.SRT_Access_Code__c='R';
        repSRT8.Solution_Number__c= solutions.id;
        repSRT8.Step_Description__c='Step Number-00';
        repSRT8.Job_Order__c=job1.id;
        repSRT8.SRT_Quantity__c=1;
        repSRT8.SRT_Order__c=4;
        repSRT8.Access_Code__c='R';
        repSRT8.isPerformed__c=True;
        repSRT8.SRT_Time__c=1.1;
        repSRT8.Assignment__c='ALTERNATIVE';
        //repSRT8.css_claims__c = Claim.id;
        repairSRT.add(repSRT8);
        
        CSS_SRT__C repSRT9 = new CSS_SRT__C();
        repSRT9.Name ='Test3';
        repSRT9.Component_Id__c=solComp.id;
        repSRT9.SRT_Type__c='Repair';
        repSRT9.Type__c='Repair';
        repSRT9.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT9.SRT_ID__c='asd';
        repSRT9.SRT_Access_Code__c='R';
        repSRT9.Solution_Number__c= solutions.id;
        repSRT9.Step_Description__c='Step Number-00';
        repSRT9.Job_Order__c=job1.id;
        repSRT9.SRT_Quantity__c=1;
        repSRT9.SRT_Order__c=4;
        repSRT9.Access_Code__c='R';
        repSRT9.isPerformed__c=True;
        repSRT9.SRT_Time__c=1.1;
        repSRT9.Assignment__c='PROGRESSIVE DAMAGE';
        //repSRT9.css_claims__c = Claim.id;
        repairSRT.add(repSRT9);
        
        CSS_SRT__C repSRT91 = new CSS_SRT__C();
        repSRT91.Name ='Test3';
        repSRT91.Component_Id__c=solComp.id;
        repSRT91.SRT_Type__c='Repair';
        repSRT91.Type__c='Repair';
        repSRT91.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT91.SRT_ID__c='asd';
        repSRT91.SRT_Access_Code__c='R';
        repSRT91.Solution_Number__c= solutions.id;
        repSRT91.Step_Description__c='Step Number-00';
        repSRT91.Job_Order__c=job1.id;
        repSRT91.SRT_Quantity__c=1;
        repSRT91.SRT_Order__c=4;
        repSRT91.Access_Code__c='R';
        repSRT91.isPerformed__c=True;
        repSRT91.SRT_Time__c=1.1;
        repSRT91.Assignment__c='NOT CLAIMABLE';
        //repSRT91.css_claims__c = Claim.id;
        repairSRT.add(repSRT91);
        
        CSS_SRT__C repSRT92 = new CSS_SRT__C();
        repSRT92.Name ='Test3';
        repSRT92.Component_Id__c=solComp.id;
        repSRT92.SRT_Type__c='Repair';
        repSRT92.Type__c='Repair';
        repSRT92.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT92.SRT_ID__c='asd';
        repSRT92.SRT_Access_Code__c='A';
        repSRT92.Solution_Number__c= solutions.id;
        repSRT92.Step_Description__c='Step Number-00';
        repSRT92.Job_Order__c=job1.id;
        repSRT92.SRT_Quantity__c=1;
        repSRT92.SRT_Order__c=4;
        repSRT92.Access_Code__c='A';
        repSRT92.isPerformed__c=True;
        repSRT92.SRT_Time__c=1.1;
        repSRT92.Assignment__c='NOT CLAIMABLE';
        //repSRT92.css_claims__c = Claim.id;
        repairSRT.add(repSRT92);
        
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '50';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        CSS_JobEventTemporary__c jET2 = new CSS_JobEventTemporary__c();
        jET2.Attribute1__c = 'NPW';
        jET2.Attribute3__c = '60';
        jET2.Attribute4__c = 'DSBDV5789';
        jET2.Key__c = 'AccountCodes';
        jETList.add(jET2);
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        
        insert jETList;
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        List<string> solCompAdd = new List<string>();
        //CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,claim.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','TYPE','3','7');
        CSS_SRT.solCompWrapper comp1 =new CSS_SRT.solCompWrapper(solComp.Solutions__c,job1.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','Campaign','3','7');
        // solCompAdd.add(system.JSON.serialize(comp));
        solCompAdd.add(system.JSON.serialize(comp1));
        CSS_SRT.repairSRT(solCompAdd);
       // CSS_SRT.repairSRTManualClaim(solCompAdd);
        double data = 120.00;
        String json3 = '{ '+
            
            '\"solID\": \"'+solutions.id+'\", '+
            '\"jobID\": \"'+job1.id+'\", '+
            '\"serviceModel\": \"serviceModel\", '+
            '\"equipID\": \"equipID\", '+
            '\"compID\": \"'+solComp.id+'\", '+
            '\"efc\": \"efc\", '+
            '\"compoName\": \"compoName\" '+
            '\"jobName\": \"jobName\" '+
            '\"claimID\": \"'+data+'\" '+
            
            '}';
        
        
        test.stopTest();
    }
    static testMethod void testRepairSrtjobnew(){
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        String json1 ='{'+
            '   \"DataArea\":    {'+
            '      \"CaseResponse\":       ['+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"A\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"UNLISTED\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"C\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"ALTERNATIVE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PROGRESSIVE DAMAGE\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
            '                  \"StepID\": 47415'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"00-724-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.3,'+
            '            \"SRTAccessCode\": \"R\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
            '                  \"StepID\": 120039'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"DIAGNOSTIC\",'+
            '            \"FlexSRT\": \"Y\",'+
            '            \"ECMFlag\": \"Y\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-057-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 0.2,'+
            '            \"SRTAccessCode\": \"A\",'+
            '            \"SRTMessage\": \"\"'+
            '         },'+
            '                  {'+
            '            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
            '            \"SRTQuantity\": 1,'+
            '            \"VerifyRepeatValue\":             {'+
            '               \"SRTType\": \"\",'+
            '               \"Step\":                {'+
            '                  \"Percentage\": 0,'+
            '                  \"SRTModifyDateTime\": \"\",'+
            '                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
            '                  \"StepID\": 19684'+
            '               },'+
            '               \"SRTEventPerfDateTime\": \"\"'+
            '            },'+
            '            \"FailureID\": \"F07000130\",'+
            '            \"Assignment\": \"PRIMARY\",'+
            '            \"FlexSRT\": \"F\",'+
            '            \"ECMFlag\": \"F\",'+
            '            \"FailureName\": \"Lubricating Oil Pan\",'+
            '            \"SRTDetails\": \"07-109-00\",'+
            '            \"CaseNumber\": \"Case001",'+
            '            \"SRTTime\": 2.2,'+
            '            \"SRTAccessCode\": \"A\",'+
            '            \"SRTMessage\": \"\"'+
            '         }'+
            '      ],'+
            '      \"ResponseMessage\": \"\"'+
            '   },'+
            '   \"Header\":    {'+
            '      \"ReturnCodeDescription\": \"\",'+
            '      \"Status\": \"Success\"'+
            '   }'+
            '}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo',token);
        endpointsResponse.put('https://services-dev-oauth.cummins.com/api/oauth/token/css',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.RecordTypeId = devRecordTypeId;
        insert acc;
        
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        //css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56',account__c=acc.id);
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F07000130',Solutions__c=solutions.Id,Service_Job__c=job1.id, 
                                                System_Code__c = 'TH', Component_Code__c = 'AC', AccountCode__c ='Krishna 65',
                                                Selected_Component__c = true);
        insert solComp;
        system.debug('solComp'+solComp);
        /* Claim = new CSS_Claims__c();
CSS_Claims__c testclaimsRec = new CSS_Claims__c();
Claim.Customer_Name__c='TestCustomer';
Claim.Account__c=acc.id;
Claim.Customer_Code__c = '1234';
Claim.Contact_Last_Name__c = 'T';
Claim.Address__c = 'T';
Claim.CSS_Job__c = job1.id;
Claim.Customer_Contact_Phone__c = null;
Claim.Email_Address__c = 'RdB@nomail.com';
Claim.Status__c = 'Draft';
Claim.Account__c=acc.Id;
insert Claim;*/
        
        
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        /*CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        //repsrt1.css_claims__c = Claim.id;
        repSRT1.SRT_Order__c=2;
        repairSRT.add(repSRT1);
        
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        //repsrt2.css_claims__c = Claim.id;
        repSRT2.SRT_Order__c=411;
        repairSRT.add(repSRT2);
        
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        // repsrt3.css_claims__c = Claim.id;
        repSRT3.SRT_Order__c=413;
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT4.Name ='Test2';
        repSRT4.Component_Id__c=solComp.id;
        repSRT4.SRT_Type__c='Diag Access';
        repSRT4.Type__c='Diag Access';
        repSRT4.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT4.SRT_ID__c='asd-00';
        repSRT4.SRT_Access_Code__c='A';
        repSRT4.Solution_Number__c= solutions.id;
        repSRT4.Step_Description__c='hgfr';
        repSRT4.Job_Order__c=job1.id;
        repSRT4.SRT_Quantity__c=1;
        repSRT4.Access_Code__c='A';
        repSRT4.isPerformed__c=True;
        repSRT4.SRT_Time__c=1.1;
        // repsrt4.css_claims__c = Claim.id;
        repSRT4.Assignment__c='PROGRESSIVE DAMAGE';
        repSRT4.SRT_Order__c=31;
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT5.Name ='Test2';
        repSRT5.Component_Id__c=solComp.id;
        repSRT5.SRT_Type__c='Diagnosis';
        repSRT5.Type__c='Diagnosis';
        repSRT5.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT5.SRT_ID__c='asd-00';
        repSRT5.SRT_Access_Code__c='A';
        repSRT5.Solution_Number__c= solutions.id;
        repSRT5.Step_Description__c='hgfr';
        repSRT5.Job_Order__c=job1.id;
        repSRT5.SRT_Quantity__c=1;
        repSRT5.Access_Code__c='A';
        repSRT5.isPerformed__c=True;
        repSRT5.SRT_Time__c=1.1;
        repSRT5.Assignment__c='PRIMARY';
        // repsrt5.css_claims__c = Claim.id;
        repSRT5.SRT_Order__c=41;
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT6.Name ='Test3';
        repSRT6.Component_Id__c=solComp.id;
        repSRT6.SRT_Type__c='Diagnosis';
        repSRT6.Type__c='Diagnosis';
        repSRT6.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT6.SRT_ID__c='asd';
        repSRT6.SRT_Access_Code__c='A';
        repSRT6.Solution_Number__c= solutions.id;
        repSRT6.Step_Description__c='Step Number-00';
        repSRT6.Job_Order__c=job1.id;
        repSRT6.SRT_Quantity__c=1;
        repSRT6.SRT_Order__c=4;
        repSRT6.Access_Code__c='A';
        repSRT6.isPerformed__c=True;
        repSRT6.SRT_Time__c=1.1;
        repSRT6.Assignment__c='PRIMARY';
        //repsrt6.css_claims__c = Claim.id;
        repairSRT.add(repSRT6);*/
        
        CSS_SRT__C repSRT7 = new CSS_SRT__C();
        repSRT7.Name ='Test3';
        repSRT7.Component_Id__c=solComp.id;
        repSRT7.SRT_Type__c='Repair';
        repSRT7.Type__c='Repair';
        repSRT7.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT7.SRT_ID__c='asd';
        repSRT7.SRT_Access_Code__c='R';
        repSRT7.Solution_Number__c= solutions.id;
        repSRT7.Step_Description__c='Step Number-00';
        repSRT7.Job_Order__c=job1.id;
        repSRT7.SRT_Quantity__c=1;
        repSRT7.SRT_Order__c=4;
        repSRT7.Access_Code__c='R';
        repSRT7.isPerformed__c=True;
        repSRT7.SRT_Time__c=1.1;
        repSRT7.Assignment__c='PRIMARY';
        //repSRT7.css_claims__c = Claim.id;
        repairSRT.add(repSRT7);
        
        CSS_SRT__C repSRT8 = new CSS_SRT__C();
        repSRT8.Name ='Test3';
        repSRT8.Component_Id__c=solComp.id;
        repSRT8.SRT_Type__c='Repair';
        repSRT8.Type__c='Repair';
        repSRT8.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT8.SRT_ID__c='asd';
        repSRT8.SRT_Access_Code__c='R';
        repSRT8.Solution_Number__c= solutions.id;
        repSRT8.Step_Description__c='Step Number-00';
        repSRT8.Job_Order__c=job1.id;
        repSRT8.SRT_Quantity__c=1;
        repSRT8.SRT_Order__c=4;
        repSRT8.Access_Code__c='R';
        repSRT8.isPerformed__c=True;
        repSRT8.SRT_Time__c=1.1;
        repSRT8.Assignment__c='ALTERNATIVE';
        //repSRT8.css_claims__c = Claim.id;
        repairSRT.add(repSRT8);
        
        CSS_SRT__C repSRT9 = new CSS_SRT__C();
        repSRT9.Name ='Test3';
        repSRT9.Component_Id__c=solComp.id;
        repSRT9.SRT_Type__c='Repair';
        repSRT9.Type__c='Repair';
        repSRT9.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT9.SRT_ID__c='asd';
        repSRT9.SRT_Access_Code__c='R';
        repSRT9.Solution_Number__c= solutions.id;
        repSRT9.Step_Description__c='Step Number-00';
        repSRT9.Job_Order__c=job1.id;
        repSRT9.SRT_Quantity__c=1;
        repSRT9.SRT_Order__c=4;
        repSRT9.Access_Code__c='R';
        repSRT9.isPerformed__c=True;
        repSRT9.SRT_Time__c=1.1;
        repSRT9.Assignment__c='PROGRESSIVE DAMAGE';
        //repSRT9.css_claims__c = Claim.id;
        repairSRT.add(repSRT9);
        
        CSS_SRT__C repSRT91 = new CSS_SRT__C();
        repSRT91.Name ='Test3';
        repSRT91.Component_Id__c=solComp.id;
        repSRT91.SRT_Type__c='Repair';
        repSRT91.Type__c='Repair';
        repSRT91.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT91.SRT_ID__c='asd';
        repSRT91.SRT_Access_Code__c='R';
        repSRT91.Solution_Number__c= solutions.id;
        repSRT91.Step_Description__c='Step Number-00';
        repSRT91.Job_Order__c=job1.id;
        repSRT91.SRT_Quantity__c=1;
        repSRT91.SRT_Order__c=4;
        repSRT91.Access_Code__c='R';
        repSRT91.isPerformed__c=True;
        repSRT91.SRT_Time__c=1.1;
        repSRT91.Assignment__c='NOT CLAIMABLE';
        //repSRT91.css_claims__c = Claim.id;
        repairSRT.add(repSRT91);
        
        /*CSS_SRT__C repSRT92 = new CSS_SRT__C();
        repSRT92.Name ='Test3';
        repSRT92.Component_Id__c=solComp.id;
        repSRT92.SRT_Type__c='Repair';
        repSRT92.Type__c='Repair';
        repSRT92.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT92.SRT_ID__c='asd';
        repSRT92.SRT_Access_Code__c='A';
        repSRT92.Solution_Number__c= solutions.id;
        repSRT92.Step_Description__c='Step Number-00';
        repSRT92.Job_Order__c=job1.id;
        repSRT92.SRT_Quantity__c=1;
        repSRT92.SRT_Order__c=4;
        repSRT92.Access_Code__c='A';
        repSRT92.isPerformed__c=True;
        repSRT92.SRT_Time__c=1.1;
        repSRT92.Assignment__c='NOT CLAIMABLE';
        //repSRT92.css_claims__c = Claim.id;
        repairSRT.add(repSRT92);*/
        
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '50';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        CSS_JobEventTemporary__c jET2 = new CSS_JobEventTemporary__c();
        jET2.Attribute1__c = 'NPW';
        jET2.Attribute3__c = '60';
        jET2.Attribute4__c = 'DSBDV5789';
        jET2.Key__c = 'AccountCodes';
        jETList.add(jET2);
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        
        insert jETList;
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        List<string> solCompAdd = new List<string>();
        //CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,claim.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','TYPE','3','7');
        CSS_SRT.solCompWrapper comp1 =new CSS_SRT.solCompWrapper(solComp.Solutions__c,job1.id,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null,'failCode','acccode','TYPE','3','7');
        // solCompAdd.add(system.JSON.serialize(comp));
        solCompAdd.add(system.JSON.serialize(comp1));
        CSS_SRT.repairSRT(solCompAdd);
        
        CSS_SRT.repairSRTManualClaim(solCompAdd);
        double data = 120.00;
        String json3 = '{ '+
            
            '\"solID\": \"'+solutions.id+'\", '+
            '\"jobID\": \"'+job1.id+'\", '+
            '\"serviceModel\": \"serviceModel\", '+
            '\"equipID\": \"equipID\", '+
            '\"compID\": \"'+solComp.id+'\", '+
            '\"efc\": \"efc\", '+
            '\"compoName\": \"compoName\" '+
            '\"jobName\": \"jobName\" '+
            '\"claimID\": \"'+data+'\" '+
            
            '}';
        
        
        test.stopTest();
    }
    static testMethod void catchblock(){
        CSS_SRT.diagnosticSRT(null, null,null,null,null,null);
        //CSS_SRT.repairSRT(null);
        //CSS_SRT.repairSRTManualClaim(null);
        CSS_SRT.splreceiveToken(null);
    }
    
}