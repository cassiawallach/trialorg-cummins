@istest
public class CMI_CustomerDelete_Test{
 
    static testMethod void  TestAPIAccountCreationResponse1(){
   
   Account acc=new Account();
   acc.Name='Customer Delete Unique-1';
   acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
   insert acc;
   
   Contact c=new Contact();
   c.LastName='Test LName';
   c.FirstName='Test FName';
   c.email='karthikgolakaram@gmail.com';
   c.AccountId=acc.id;
   insert c;
   
   
   
   CMI_TSP__c tsp=new CMI_TSP__c();
   tsp.CMI_Account_Name__c=acc.id;
   tsp.CMI_TSP_Id__c='testingTSPID1234';
   tsp.CMI_TSP_Name__c='DriverTech';
   tsp.CMI_Telematics_ID__c='telematicsID';
   insert tsp;
    
    List<Account> accnt=[Select id,name,CMI_CId__c from Account where Name='Customer Delete Unique-1'  ];
     
   String JsonMsg = JSON.serialize('Test');
     
  
  // Test.startTest(); 
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();         
   req.requestURI = '/services/apexrest/Customer/Delete/';  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;
   CMI_CustomerDelete.DeactivateCompanyPayload payload = new CMI_CustomerDelete.DeactivateCompanyPayload();
    payload.CustomerSK= accnt[0].CMI_CId__c;
    payload.accountName= accnt[0].Name;
    payload.tspname='DriverTech';
    payload.tspcustRef='testingTSPID1234';
    
    CMI_CustomerDelete.CMI_ResponseHandler response = CMI_CustomerDelete.Post(payload);
       
   }
   
   static testMethod void  TestAPIAccountCreationResponse2(){
   
   Account acc=new Account();
   acc.Name='Customer Delete Unique-2';
   acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
   insert acc;
   
   Contact c=new Contact();
   c.LastName='Test LName';
   c.FirstName='Test FName';
   c.email='karthikgolakaram23@gmail.com';
   c.AccountId=acc.id;
   insert c;
   
   
   
   CMI_TSP__c tsp=new CMI_TSP__c();
   tsp.CMI_Account_Name__c=acc.id;
   tsp.CMI_TSP_Id__c='testingTSPID12345';
   tsp.CMI_TSP_Name__c='DriverTech';
   tsp.CMI_Telematics_ID__c='telematID-2';
   insert tsp;
    
    List<Account> accnt=[Select id,name,CMI_CId__c from Account where Name='Customer Delete Unique-2'  ];
     
   String JsonMsg = JSON.serialize('Test');
     
  
  // Test.startTest(); 
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();         
   req.requestURI = '/services/apexrest/Customer/Delete/';  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;
   CMI_CustomerDelete.DeactivateCompanyPayload payload = new CMI_CustomerDelete.DeactivateCompanyPayload();
    payload.CustomerSK= '';
    payload.accountName= '';
    payload.tspname='';
    payload.tspcustRef='';
    
    CMI_CustomerDelete.CMI_ResponseHandler response = CMI_CustomerDelete.Post(payload);
    
    //Calling with other payload
    CMI_CustomerDelete.DeactivateCompanyPayload payload1 = new CMI_CustomerDelete.DeactivateCompanyPayload();
    payload1.CustomerSK= '1212211';
    payload1.accountName= '123456789012345678901234567890123456789012345678901234567890';
    payload1.tspname='adafadsfdasfadscxzxcvasdsfadscdscadscxzdsafvasdfvadsfcdscsdacfadscf';
    payload1.tspcustRef='fadsfcdas';
    
    CMI_CustomerDelete.CMI_ResponseHandler response1 = CMI_CustomerDelete.Post(payload1);
       
   
   
   }
 }