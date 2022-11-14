@isTest()
public class CSS_BMSSendJobPlan_Test {
    @testsetup static void testdata()
    {
         CSS_Job_Order__c jobOrder = new css_job_order__c();
       jobOrder.Status__c = 'intake';
        jobOrder.Shop_Work_Order__c='1234';
        jobOrder.Unit_Number__c='12345';
       jobOrder.CSS_Job_Location_Code__c='02957-02957'; 
        insert jobOrder;
       
        
    }
     public static testMethod void testJobOrderData(){
       
        CSS_Job_Order__c jobName = [SELECT Name,Status__c,Unit_Number__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        string jsonRequestBody = '{'+
'  \"Header\": {'+
 '   \"Sender\": {'+
  '    \"ServiceName\": \"SendJobPlan\",'+
   '   \"SenderID\": \"BMS\"'+
   ' },'+
   ' \"Target\": {'+
    '  \"TargetID\": \"CSS\"'+
    '},'+
    '\"Location\": {'+
    '  \"LocationID\": \"02957-02957\"'+
    '}'+
 ' },'+
  '\"DataArea\": {'+
   ' \"CSSjobID\": \"'+jobName.name+'\",'+
'\"DistributorCode\": \"02957\",'+
   ' \"BranchCode\": \"02957\",'+
   ' \"CustomerCode\": \"02957\",'+
    '\"OrderSourceType\": \"WO\",'+
   ' \"BMSReferenceNumber\": \"987\",'+
   ' \"SRTDetails\": ['+
   '   {'+
    '    \"SRTGroup\": \"00\",'+
     '   \"Procedure\": \"980\",'+
     '   \"Step\": \"02\",'+
      '  \"Quantity\": 4,'+
      '  \"SRTHour\": 2.4,'+
      '  \"ActualHour\": 6,'+
       ' \"BilledHour\": 5.2,'+
       ' \"Bill\": \"\",'+
       ' \"Troubleshoot\": \"\",'+
       ' \"Flexible\": \"\",'+
       ' \"PrivateWork\": \"\",'+
       ' \"ServiceModelName\": \"\",'+
       ' \"Title\": \"\",'+
       ' \"SortOrder\": 1,'+
       ' \"Access\": \"\",'+
       ' \"WarrantyAllocation\": 60,'+
        '\"AdjustmentReason\": \"\",'+
       ' \"AccountCode\": \"\",'+
       ' \"ClaimType\": \"\",'+
       ' \"CreateDate\": \"\",'+
       ' \"CreateUser\": \"\",'+
       ' \"ChangeDate\": \"\",'+
       ' \"ChangeUser\": \"\"'+
      '},'+
      '{'+
       ' \"SRTGroup\": \"00\",'+
       ' \"Procedure\": \"980\",'+
        '\"Step\": \"02\",'+
        '\"Quantity\": 4,'+
        '\"SRTHour\": 2.4,'+
        '\"ActualHour\": 6,'+
        '\"BilledHour\": 5.2,'+
        '\"Bill\": \"\",'+
        '\"Troubleshoot\": \"\",'+
        '\"Flexible\": \"\",'+
        '\"PrivateWork\": \"\",'+
        '\"ServiceModelName\": \"\",'+
        '\"Title\": \"\",'+
        '\"SortOrder\": 1,'+
        '\"Access\": \"\",'+
        '\"WarrantyAllocation\": 60,'+
        '\"AdjustmentReason\": \"\",'+
        '\"AccountCode\": \"\",'+
        '\"ClaimType\": \"\",'+
        '\"CreateDate\": \"\",'+
        '\"CreateUser\": \"\",'+
        '\"ChangeDate\": \"\",'+
        '\"ChangeUser\": \"\"'+
      '}'+
    ']'+
  '}'+
'}';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/BMS/V01/CSS/BMSSendJobPlanToGuidanz/';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CSS_BMSSendJobPlan.insertBMS_SRT_Data(); 
        Test.stopTest();
     }
   
      public static testMethod void testJobOrderData2(){
        CSS_Job_Order__c jobOrder = new css_job_order__c();
       jobOrder.Status__c = 'intake';
        jobOrder.Shop_Work_Order__c='1234';
        jobOrder.Unit_Number__c='12345';
       jobOrder.CSS_Job_Location_Code__c='02957-02957'; 
        insert jobOrder;
        CSS_Job_Order__c jobName = [SELECT Name,Status__c,Unit_Number__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        string jsonRequestBody = '{'+
'  \"Header\": {'+
 '   \"Sender\": {'+
  '    \"ServiceName\": \"SendJobPlan\",'+
   '   \"SenderID\": \"BMS\"'+
   ' },'+
   ' \"Target\": {'+
    '  \"TargetID\": \"CSS\"'+
    '},'+
    '\"Location\": {'+
    '  \"LocationID\": \"02957-02957\"'+
    '}'+
 ' },'+
  '\"DataArea\": {'+
   ' \"CSSjobID\": \"'+jobName.id+'\",'+
'\"DistributorCode\": \"02957\",'+
   ' \"BranchCode\": \"02957\",'+
   ' \"CustomerCode\": \"02957\",'+
    '\"OrderSourceType\": \"WO\",'+
   ' \"BMSReferenceNumber\": \"987\",'+
   ' \"SRTDetails\": ['+
   '   {'+
          ' \"Group\": \"00\",'+
       ' \"Procedure\": \"980\",'+
        '\"Step\": \"02\",'+
        '\"Quantity\": 4,'+
        '\"SRTHour\": 2.4,'+
        '\"ActualHour\": 6,'+
        '\"BilledHour\": 5.2,'+
        '\"Bill\": \"\",'+
        '\"Troubleshoot\": \"\",'+
        '\"Flexible\": \"\",'+
        '\"PrivateWork\": \"\",'+
        '\"ServiceModelName\": \"\",'+
        '\"Title\": \"\",'+
        '\"SortOrder\": 1,'+
        '\"Access\": \"\",'+
        '\"WarrantyAllocation\": 60,'+
        '\"AdjustmentReason\": \"\",'+
        '\"AccountCode\": \"\",'+
        '\"ClaimType\": \"\",'+
        '\"CreateDate\": \"\",'+
        '\"CreateUser\": \"\",'+
        '\"ChangeDate\": \"\",'+
        '\"ChangeUser\": \"\"'+
      '}'+
    ']'+
  '}'+
'}';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/BMS/V01/CSS/BMSSendJobPlanToGuidanz/'; 
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CSS_BMSSendJobPlan.insertBMS_SRT_Data(); 
        Test.stopTest();
     }
 public static testMethod void testJobOrderData4(){
       string tempSRTID = 'Testing';
        CSS_Job_Order__c jobName = [SELECT Name,Status__c,Unit_Number__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        string jsonRequestBody = '{'+
'  \"Header\": {'+
 '   \"Sender\": {'+
  '    \"ServiceName\": \"SendJobPlan\",'+
   '   \"SenderID\": \"BMS\"'+
   ' },'+
   ' \"Target\": {'+
    '  \"TargetID\": \"CSS\"'+
    '},'+
    '\"Location\": {'+
    '  \"LocationID\": \"02957-02957\"'+
    '}'+
 ' },'+
  '\"DataArea\": {'+
   ' \"CSSjobID\": \"'+jobName.name+'\",'+
'\"DistributorCode\": \"02957\",'+
   ' \"BranchCode\": \"02957\",'+
   ' \"CustomerCode\": \"02957\",'+
    '\"OrderSourceType\": \"WO\",'+
   ' \"BMSReferenceNumber\": \"987\",'+
   ' \"SRTDetails\": ['+
   '   {'+
       ' }'+
    ']'+
  '}'+
'}';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/BMS/V01/CSS/BMSSendJobPlanToGuidanz/';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CSS_BMSSendJobPlan.insertBMS_SRT_Data(); 
        Test.stopTest();
     }
 
}