/**********************************************************************
Name: CSS_receiveBMSCommentOutboundData_Test
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for CSS_receiveBMSCommentOutboundData
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Moulika G        06/07/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
global class CSS_receiveBMSCommentOutboundData_Test
{
    @testSetup static void createTestData() 
    {
        list<CSS_Job_Order__c> jobOrder = new list<CSS_Job_Order__c>();
        
        CSS_Job_Order__c joborder1 = new CSS_Job_Order__c();
        jobOrder1.Status__c = 'Job Plan';
        jobOrder1.CSS_Job_Location_Code__c='02400-02394'; 
        jobOrder.add(joborder1);
        
        insert jobOrder;
    }
    static testMethod void testCSS_receiveBMSCommentOutboundData1() 
    {
        
        list<CSS_Job_Order__c> jobOrder = [SELECT Name,Status__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
         //Input JSON Request
        String JSONReq = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"sendBMSComments\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"'+jobOrder[0].name+'\",'+
		'		\"DistributorCode\": \"02400\",'+
		'		\"BranchCode\": \"02394\",'+
		'		\"BMSReferenceNumber\": \"98687687\",'+
		'		\"OrderSourceType\": \"WO/WOQT\",'+
		'		\"CommentType\": \"COVERAGE\",'+
		'		\"ServiceComment\": \"MW to merge the SERVICE_COMMENT if there are multiple line items in the order of serv_comment_seq_no\",'+
		'		\"CreateUser\": \"WWID\",'+
		'		\"CreateDate\": \"Date\",'+
		'		\"ChangeUser\": \"WWID\",'+
		'		\"ChangeDate\": \"Date\"'+
		'	}'+
		'}';
        
        
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestUri ='https://cummins--cssdev.cs50.my.salesforce.com/services/apexrest/BMS/V01/CSS/UpdateBMSCommentsInGuidanz/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        Test.startTest();
        CSS_receiveBMSCommentOutboundData.updateBMSCommentOutboundData(); //Invoke the service
		Test.stopTest();
    }
    static testMethod void testCSS_receiveBMSCommentOutboundData2()
    {
        list<CSS_Job_Order__c> jobOrder = [SELECT Name,Status__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        //Input JSON Request
        String JSONReq = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"sendBMSComments\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"'+jobOrder[0].name+'\",'+
		'		\"DistributorCode\": \"02400\",'+
		'		\"BranchCode\": \"02394\",'+
		'		\"BMSReferenceNumber\": \"98687687\",'+
		'		\"OrderSourceType\": \"WO/WOQT\",'+
		'		\"CommentType\": \"COMPLAINT\",'+
		'		\"ServiceComment\": \"Please Enter a value",'+
		'		\"CreateUser\": \"WWID\",'+
		'		\"CreateDate\": \"Date\",'+
		'		\"ChangeUser\": \"WWID\",'+
		'		\"ChangeDate\": \"Date\"'+
		'	}'+
		'}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestUri ='https://cummins--cssdev.cs50.my.salesforce.com/services/apexrest/BMS/V01/CSS/UpdateBMSCommentsInGuidanz/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        Test.startTest();
        CSS_receiveBMSCommentOutboundData.updateBMSCommentOutboundData(); //Invoke the service
		Test.stopTest();
    
    }
     static testMethod void testCSS_receiveBMSCommentOutboundData3()
    {
        list<CSS_Job_Order__c> jobOrder = [SELECT Name,Status__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        //Input JSON Request
        String JSONReq = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"sendBMSComments\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"'+jobOrder[0].name+'\",'+
		'		\"DistributorCode\": \"02400\",'+
		'		\"BranchCode\": \"02394\",'+
		'		\"BMSReferenceNumber\": \"98687687\",'+
		'		\"OrderSourceType\": \"WO/WOQT\",'+
		'		\"CommentType\": \"Cause\",'+
		'		\"ServiceComment\": \"This is Cause",'+
		'		\"CreateUser\": \"WWID\",'+
		'		\"CreateDate\": \"Date\",'+
		'		\"ChangeUser\": \"WWID\",'+
		'		\"ChangeDate\": \"Date\"'+
		'	}'+
		'}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestUri ='https://cummins--cssdev.cs50.my.salesforce.com/services/apexrest/BMS/V01/CSS/UpdateBMSCommentsInGuidanz/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        Test.startTest();
        CSS_receiveBMSCommentOutboundData.updateBMSCommentOutboundData(); //Invoke the service
		Test.stopTest();
    
    }
      static testMethod void testCSS_receiveBMSCommentOutboundData4()
    {
        list<CSS_Job_Order__c> jobOrder = [SELECT Name,Status__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        //Input JSON Request
        String JSONReq = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"sendBMSComments\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"'+jobOrder[0].name+'\",'+
		'		\"DistributorCode\": \"02400\",'+
		'		\"BranchCode\": \"02394\",'+
		'		\"BMSReferenceNumber\": \"98687687\",'+
		'		\"OrderSourceType\": \"WO/WOQT\",'+
		'		\"CommentType\": \"Correction\",'+
		'		\"ServiceComment\": \"This is Correction",'+
		'		\"CreateUser\": \"WWID\",'+
		'		\"CreateDate\": \"Date\",'+
		'		\"ChangeUser\": \"WWID\",'+
		'		\"ChangeDate\": \"Date\"'+
		'	}'+
		'}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestUri ='https://cummins--cssdev.cs50.my.salesforce.com/services/apexrest/BMS/V01/CSS/UpdateBMSCommentsInGuidanz/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        Test.startTest();
        CSS_receiveBMSCommentOutboundData.updateBMSCommentOutboundData(); //Invoke the service
		Test.stopTest();
    
    }
     static testMethod void testCSS_receiveBMSCommentOutboundData5()
    {
        list<CSS_Job_Order__c> jobOrder = [SELECT Name,Status__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        //Input JSON Request
        String JSONReq = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"sendBMSComments\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"'+jobOrder[0].name+'\",'+
		'		\"DistributorCode\": \"02400\",'+
		'		\"BranchCode\": \"02394\",'+
		'		\"BMSReferenceNumber\": \"98687687\",'+
		'		\"OrderSourceType\": \"WO/WOQT\",'+
		'		\"CommentType\": \"SRO\",'+
		'		\"ServiceComment\": \"This is SRO",'+
		'		\"CreateUser\": \"WWID\",'+
		'		\"CreateDate\": \"Date\",'+
		'		\"ChangeUser\": \"WWID\",'+
		'		\"ChangeDate\": \"Date\"'+
		'	}'+
		'}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestUri ='https://cummins--cssdev.cs50.my.salesforce.com/services/apexrest/BMS/V01/CSS/UpdateBMSCommentsInGuidanz/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        Test.startTest();
        CSS_receiveBMSCommentOutboundData.updateBMSCommentOutboundData(); //Invoke the service
		Test.stopTest();
    
    }
     static testMethod void testCSS_receiveBMSCommentOutboundData6()
    {
        //Input JSON Request
        String JSONReq = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"sendBMSComments\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'	}'+
		'}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestUri ='https://cummins--cssdev.cs50.my.salesforce.com/services/apexrest/BMS/V01/CSS/UpdateBMSCommentsInGuidanz/';
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.response= res;
        RestContext.request = req;
        Test.startTest();
        CSS_receiveBMSCommentOutboundData.updateBMSCommentOutboundData(); //Invoke the service
		Test.stopTest();
    
    }
}