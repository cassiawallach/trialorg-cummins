@istest
public class CMI_CustomerUser_Test{
 
    static testMethod void  TestCMI_CustomerUserResponse1(){
   
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
   
   contact c2=new Contact();
   c2.LastName='Unknown';
   c2.FirstName='Unknown';
   c2.email='karthikgolakaram@gmail.com';
   c2.CMI_Contact_Type__c='Primary';
   c2.AccountId=acc.id;
   
   List<Contact> c=new List<Contact>();
   c.add(c1);
   c.add(c2);
   insert c;
   
   
   
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
   req.requestURI = '/services/apexrest/Customer/User/';  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;
   CMI_CustomerUser.UserInfo payload = new CMI_CustomerUser.UserInfo();
    payload.cId= accnt[0].CMI_CId__c;
    payload.firstname='Fname-1';
    payload.lastname='LName-1';
    payload.email='testingemailuser@cummins.com';
    payload.operation='Create';
    
    CMI_CustomerUser.CMI_ResponseHandler response = CMI_CustomerUser.Post(payload);
    
    //This Payload is for update of the contact that was created in above list.
    CMI_CustomerUser.UserInfo payload1 = new CMI_CustomerUser.UserInfo();
    payload1.cId= accnt[0].CMI_CId__c;
    payload1.firstname='Fname-1';
    payload1.lastname='LName-2';
    payload1.email='karthikgolakaram1@gmail.com';
    
    payload1.operation='Update';
//    payload1.CMI_Contact_Type__c='Primary';


    
    
    
    CMI_CustomerUser.CMI_ResponseHandler response2 = CMI_CustomerUser.Post(payload1);
       
   }
   
   
 }