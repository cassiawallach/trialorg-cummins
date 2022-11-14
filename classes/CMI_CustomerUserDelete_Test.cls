@istest
public class CMI_CustomerUserDelete_Test{
 
    static testMethod void  TestCMI_CustomerUserDeleteResponse1(){
   
   Account acc=new Account();
   acc.Name='Customer User Unique-1';
   acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
   acc.CMI_Account_Status__c='Active';
   insert acc;
   
   Contact c1=new Contact();
   
   c1.LastName='Test LName';
   c1.FirstName='Test FName';
   c1.email='karthikgolakaram@gmail.com';
   c1.CMI_Contact_Type__c='Secondary';
   c1.AccountId=acc.id;
   
   insert c1;
   
   
   
   CMI_TSP__c tsp=new CMI_TSP__c();
   tsp.CMI_Account_Name__c=acc.id;
   tsp.CMI_TSP_Id__c='testTSPID1234';
   tsp.CMI_TSP_Name__c='DriverTech';
   tsp.CMI_Telematics_ID__c='telematiID';
   insert tsp;
    
    List<Account> accnt=[Select id,name,CMI_CId__c from Account where Name='Customer User Unique-1'  ];
     
   String JsonMsg = JSON.serialize('Test');
     
  
  // Test.startTest(); 
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();         
   req.requestURI = '/services/apexrest/Customer/User/Delete/';  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;
   CMI_CustomerUserDelete.UserDeleteInfo payload = new CMI_CustomerUserDelete.UserDeleteInfo();
    payload.cId= accnt[0].CMI_CId__c;
    payload.firstname='Fname-1';
    payload.lastname='LName-1';
    payload.email='testingemailuser@cummins.com';
    
    
    CMI_CustomerUserDelete.CMI_ResponseHandler response = CMI_CustomerUserDelete.Post(payload);
    
   
       
   }
   
   
 }