@istest
public class CSS_SiebelSendClaimStatusInbound_test {
    
    @testsetup static void testdatamethod()
    {
        css_claims__c claims= new css_claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        insert claims;
      css_claims__c claims1=[select id,name from css_claims__c limit 1];      
            CSS_Claim_Submission__c claimssub= new CSS_Claim_Submission__c();
            claimssub.CSS_Claims__c=claims.Id;
            claimssub.Individual_Claim_Id__c=claims1.Name;
        insert claimssub;
           Note nw = new note();
        nw.Body='SBL928734;;2010-03-19 16:18:59;;2010-03-19 16:18:59;;Review SRTs times';
        nw.ParentId=claimssub.Id;
        nw.Title='Claims';
        insert nw;
            
  
    }
    static testmethod void testmethod1()
        
    {
        CSS_Claim_Submission__c claimssub1=[select id,name,Individual_Claim_Id__c from CSS_Claim_Submission__c limit 1];
          test.startTest();
        RestRequest req = new RestRequest();
         req.addHeader('Content-Type', 'application/json');
       req.httpMethod = 'PUT';
        req.requestURI = 'https://cummins--cssdev.cs50.my.salesforce.com/services/apexrest/Siebel/V01/CSS/SiebelSendClaimStatusToGuidanz/*';
        req.requestBody=blob.valueOf('{ "Header": { "Target": { "TargetID": "CSS", "SourceEnvironment": "CGCDWTST" }, "Sender": { "ServiceName": "sendClaimStatus", "SenderID": "SIEBEL" } }, "DataArea": { "SiebelClaimNumber": "044023", "GuidanzClaimNumber": "'+claimssub1.Individual_Claim_Id__c+'", "ClaimStatus": "In Review", "NoteDetails": [ { "Note": "Parts have been removed", "NoteType": "Parts", "RowId": "SBL928734", "LastUpdateDate": "2010-03-19T16:18:59", "CreatedDate": "2010-03-19T16:18:59" }, { "Note": "Review SRTs times", "NoteType": "General", "RowId": "SBL928734", "LastUpdateDate": "2010-03-19T16:18:59", "CreatedDate": "2010-03-19T16:18:59" } ] } }');
        RestContext.request = req;
        RestResponse rs = new RestResponse();
        Restcontext.response=rs;
      
       CSS_SiebelSendClaimStatusInbound.insertSiebelClaimsData();
        test.stopTest();
      
    }
    static testmethod void testmethod2()
        
    {
        
          test.startTest();
        RestRequest req = new RestRequest();
         req.addHeader('Content-Type', 'application/json');
       req.httpMethod = 'PUT';
        req.requestURI = 'https://cummins--cssdev.cs50.my.salesforce.com/services/apexrest/Siebel/V01/CSS/SiebelSendClaimStatusToGuidanz/*';
        req.requestBody=blob.valueOf('{ "Header": { "Target": { "TargetID": "CSS", "SourceEnvironment": "CGCDWTST" }, "Sender": { "ServiceName": "sendClaimStatus", "SenderID": "SIEBEL" } }, "DataArea": { "SiebelClaimNumber": "044023", "GuidanzClaimNumber": "c09089070", "ClaimStatus": "In Review", "NoteDetails": [ { "Note": "Parts have been removed", "NoteType": "Parts", "RowId": "SBL928734", "LastUpdateDate": "2010-03-19T16:18:59", "CreatedDate": "2010-03-19T16:18:59" }, { "Note": "Review SRTs times", "NoteType": "General", "RowId": "SBL928734", "LastUpdateDate": "2010-03-19T16:18:59", "CreatedDate": "2010-03-19T16:18:59" } ] } }');
        RestContext.request = req;
        RestResponse rs = new RestResponse();
        Restcontext.response=rs;
      
       CSS_SiebelSendClaimStatusInbound.insertSiebelClaimsData();
        
        
        test.stopTest();
      
    }

}