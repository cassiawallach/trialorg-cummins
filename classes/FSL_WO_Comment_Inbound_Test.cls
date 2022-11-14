/**********************************************************************
Name: FSL_WO_Comment_Inbound_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose: Test class for FSL_WO_Comment_Inbound class
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE          DETAIL                                 
1.0       Harsha              19-Feb-2020    INITIAL DEVELOPMENT  

***********************************************************************/
@isTest
public class FSL_WO_Comment_Inbound_Test {
        @testSetup static void dataSetup() 
        {   
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician'];
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', ERP__c = 'BMS',
                                 LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com', isActive = true);
        insert objUser1;
        }
    
    // method to Test WOCommentInbound
    static TestMethod void testWOCommentInbound() {
         String CSSJobID = 'J6666';
         String location = 'D3344-D3345-D3346';
         String branchNumber = 'B223344';
         String orderType = 'O3344';
         String BMSReferenceNumber = '';
         String commentType = 'extraa';
         String comment = null;
         User usr = new User();
         usr = [SELECT Id, ERP__c FROM User
               WHERE UserName='css-cmi2@cummins.com' limit 1
              ];    
         FSL_WOCommentInboundJson2Apex commentInboundDetails;
         Test.startTest();
             Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC('{"Header":{"Sender":{"ServiceName":"SetComment","SenderID":"CSS"},"Status":"SUCCESS","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"","Location":{"LocationID":"D3344-D3345-D3346"}}}')); 
             System.runAs(usr){
                  commentInboundDetails = FSL_WO_Comment_Inbound.callWOCommentInboundService(location, CSSJobID, OrderType, BMSReferenceNumber, CommentType, Comment, '', '', '', '');
                   System.debug('commentInboundDetails '+ commentInboundDetails)    ;
                   String responseMessageStatus = commentInboundDetails.Header.Status;
                   System.assert(responseMessageStatus.contains('SUCCESS'));
             }
         Test.stopTest();
    }
    
    //method to Test WOCommentInboundfailure
    static TestMethod void testWOCommentInboundfailure() {
         String CSSJobID = 'J6666';
         String location = 'D3344-D3345-D3346';
         String branchNumber = 'B223344';
         String orderType = 'O3344';
         String BMSReferenceNumber = '';
         String commentType = 'extraa';
         String comment = null;
        // Set mock callout class
         User usr = new User();
         usr = [SELECT Id, ERP__c FROM User
               WHERE UserName='css-cmi2@cummins.com' limit 1 
              ];    
       
        FSL_WOCommentInboundJson2Apex commentInboundDetails;
                
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC('{"Header":{"Sender":{"ServiceName":"SetComment","SenderID":"CSS"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"","Location":{"LocationID":" -"}}}')); 
            System.runAs(usr){
                commentInboundDetails = FSL_WO_Comment_Inbound.callWOCommentInboundService('  - ', CSSJobID, OrderType, BMSReferenceNumber, CommentType, Comment, '', '', '', '');
               
                if(commentInboundDetails!= null){
                    String responseMessageStatus = commentInboundDetails.Header.Status;
                	System.assert(responseMessageStatus.contains('ERROR'));	
                }
                
            }   
        Test.stopTest();
    }
     static TestMethod void testWOCommentInboundException() {
         String CSSJobID = 'J6666';
         String location = 'D3344-D3345-D3346';
         String branchNumber = 'B223344';
         String orderType = 'O3344';
         String BMSReferenceNumber = '';
         String commentType = 'extraa';
         String comment = null;
        // Set mock callout class
         User usr = new User();
         usr = [SELECT Id, ERP__c FROM User
               WHERE UserName='css-cmi2@cummins.com' limit 1 
              ];    
       
        FSL_WOCommentInboundJson2Apex commentInboundDetails;
                
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC('{"Header":{"Sender":{"ServiceName":"SetComment","SenderID":"CSS"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"","Location":{"LocationID":" -"}}}')); 
            System.runAs(usr){
                commentInboundDetails = FSL_WO_Comment_Inbound.callWOCommentInboundService('  -', CSSJobID, OrderType, BMSReferenceNumber, CommentType, Comment, '', '', '', '');
                
               System.assertEquals(null,commentInboundDetails);
                
            }   
        Test.stopTest();
    }
}