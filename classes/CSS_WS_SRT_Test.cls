/**********************************************************************
Name: CSS_WS_SRT_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_WS_SRT 
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0       Prabhakar Ragula          03/10/2016    INITIAL DEVELOPMENT 

***********************************************************************/


@isTest
public class CSS_WS_SRT_Test{
    
    
     @isTest static void testIntegrationError(){
        CSS_WS_SRT.logIntegrationError('hello','SRT');
    }
     @isTest static void testAccessToken(){
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        CSS_WS_SRT.getAccessToken();
    }

    @isTest static void testgetAllSRTRepair(){
        list<CSS_Job_Order__c> joborderlist = new list<CSS_Job_Order__c>();
        CSS_Job_Order__c joborder = new CSS_Job_Order__c();
        joborder = CSS_TestData.createJobOrder(false);
        joborder.Equipment_ID__c = 'test123';
        joborder.Qsol_Engine_Family_Code__c = '41';
        joborder.Service_Model__c = 'EX123';
        joborder.Claim_No__c=1234;
        joborder.AccessCode__c = 'B';
        joborderlist.add(joborder);
        //testAccessToken();
        //insert joborder;
          //css_job_order__c joborder1 = new css_job_order__c();
          CSS_Job_Order__c joborder1 = new CSS_Job_Order__c();
        joborder1 = CSS_TestData.createJobOrder(false);
         joborder1.Equipment_ID__c = 'test1';
         joborder1.Qsol_Engine_Family_Code__c = '411';
         joborder1.Service_Model__c = 'EX1231';
         joborder1.Claim_No__c=12341;
         joborder1.AccessCode__c = 'R';
         joborderlist.add(joborder1);
         insert joborderlist;
        
        string Json =  '{'+
            ' \"Header\": {'+
            
            '  \"Sender\": {'+
            '  \"ServiceName\":\"GetOverlapSRT\",'+
            '  \"SenderID\":\"CSS\" '+
            '   },'+
            '  \"Target\":{\"TargetID\":\"SRT\"}'+        
            '  },'+
            '   \"DataArea\":{'+
            
            '  \"JobId\":\"CSS-000001234\",'+
            '  \"ClaimID\":\"C100002045\",'+
            '  \"Languagecode\":\"en\",'+
            '  \"DTTimestamp\":\"28-OCT-16 06:03:12 PM\",'+
            '   \"EffectiveDTTime\":\"28-OCT-16 06:03:12 AM\",'+
            '  \"Steps\":[{ '+
            '  \"StepId\": 1234,'+
            '  \"Qty\": 2,'+
            '  \"AccessCode\":\"R\" '+
            '    } ]}'+
            '}';

        CSS_OverlapSRTReq obj1 = CSS_OverlapSRTReq.parse(json);
        
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
       
        CSS_WS_SRT.prepareReqJSONForMakeModalEquipmentId(null);
       	Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
       	CSS_WS_SRT.prepareReqJSONForMakeModalEquipmentId(null);
        CSS_WS_SRT.getAllDigRepSRTs(joborder.id,'Repair');
         CSS_OverlapSRTResponse overreq = new CSS_OverlapSRTResponse();
         overreq=CSS_WS_SRT.getOverlapSRTRecords(obj1);
         
        Test.stopTest();
         
    }
     @isTest static void testgetAllSRTDiag(){
         list<CSS_Job_Order__c> joborderlist = new list<CSS_Job_Order__c>();
        CSS_Job_Order__c joborder = new CSS_Job_Order__c();
        joborder = CSS_TestData.createJobOrder(false);
         //joborder.name = 'test';
         joborder.Equipment_ID__c = 'test';
         joborder.Qsol_Engine_Family_Code__c = '41';
         joborder.Service_Model__c = 'EX123';
         joborder.AccessCode__c = 'B';
         joborderlist.add(joborder);
         //insert joborder;
           //css_job_order__c joborder1 = new css_job_order__c();
           CSS_Job_Order__c joborder1 = new CSS_Job_Order__c();
        joborder1 = CSS_TestData.createJobOrder(false);
         joborder1.Equipment_ID__c = 'test1';
         joborder1.Qsol_Engine_Family_Code__c = '411';
         joborder1.Service_Model__c = 'EX1231';
         joborder1.Claim_No__c=12341;
         joborder1.AccessCode__c = 'R';
         joborderlist.add(joborder1);
         insert joborderlist;
         list<CSS_Claims__c> lst = new list<CSS_Claims__c>();
         CSS_Claims__c claims = new CSS_Claims__c();
        //laims.Status__c='Submitted';
         claims.AccessCode__c='Test';
         claims.Service_Model__c='test';
         //aims.id='1265';
        //laims.ESN__c='79462880';
        //laims.Customer_Name__c='BRITESTONE COLONY';
        //laims.Customer_Code__c='123';
        //laims.Location_Code__c='56270-56255';
        //laims.ownerId = UserInfo.getUserId();
         insert claims;
         lst.add(claims);
         
         list<CSS_PSN__c> psnlst = new list<CSS_PSN__c>();
         CSS_PSN__c psn = new CSS_PSN__c();
         psn.AccessCode__c='7895';
         psn.Application__c='Automotive';
         psn.Primary__c=true;
         psn.CSS_Claims__c=claims.id;
         psn.Service_Model__c='test';
         insert psn;
         psnlst.add(psn);
         
         String json = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"GetPartsListSRT\",'+
		'			\"SenderID\": \"CSS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"SRT\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"Jobid\": \"CSS-000001234\",'+
		'		\"ClaimID\": \"C100002045\",'+
		'		\"Languagecode\": \"en\",'+
		'		\"EngineFamilyCode\": \"10\",'+
		'		\"ServiceModelName\": \" ISX15 CM2350 X101\",'+
		'		\"EquipmentID\": \" EQ1234\",'+
		'		\"DTTimestamp\": \"DD-MMM-YY HH:MI:SS AM\",'+
		'		\"EffectiveDTTime\": \"DD-MMM-YY HH:MI:SS AM\",'+
		'		\"FailureID\": ['+
		'			\"F19000580\",'+
		'			\"F19000678\"'+
		'		],'+
		'		\"OptionsList\": ['+
		'			\"Option1\",'+
		'			\"Option2\"'+
		'		]'+
		'	}'+
		'}';
         
		CSS_getPartsListSRTRequestJ2A obj = CSS_getPartsListSRTRequestJ2A.parse(json);
         
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
         
             Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
             //Test.startTest();  
             CSS_WS_SRT.getAllDigRepSRTs(joborder.id,'Diagnostic');
          CSS_WS_SRT.getAllClaimsDigRepSRTs(claims.id,'test');
          CSS_WS_SRT.getAccessSRTs(joborder.id,joborder.Name,joborder.Service_Model__c,joborder.Equipment_ID__c,joborder.Qsol_Engine_Family_Code__c,'A',10,'test');
         CSS_getPartsListSRTResponseJ2A partlst = new CSS_getPartsListSRTResponseJ2A();
         
         partlst=CSS_WS_SRT.getPartsListSRT(obj);
         Test.stopTest();
    }
    
    @isTest static void testgetAllSRTDiagreceiveSpecialToken(){
        test.startTest();
        String s= CSS_WS_SRT.splreceiveToken('SRT');
        test.stopTest();
        
    }
    
    
}