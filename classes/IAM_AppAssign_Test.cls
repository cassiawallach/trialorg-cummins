@isTest
public class IAM_AppAssign_Test {
    
    /* Function used to create sample record for this test Class*/
    
    @isTest(SeeAllData=true)
    Static void InitData1(){
       
       
       Contact c= new Contact();
    c.AccountId=[Select id,recordtype.Name,parentid From Account where Name =:'Identity Individual Users' limit 1].id;
    c.FirstName='TestArcher';
    c.LastName='LastArcher';
    c.Email='oh611@cummins.com';
    c.IAM_Cummins_Login_ID__c='testemailarcheruser@gmail.com';
    c.RecordTypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    c.IAM_Contact_Status__c = 'Active';
    c.IAM_Approved__c='N';           
    c.CMI_Contact_Type__c='Secondary';
    c.IAM_from_Registration__c=true;
    c.IAM_Agreement_Signed_By__c = c.FirstName + ' '+ c.LastName;
    c.IAM_Agreement_Signed_On__c = date.today();
    c.IAM_Ext_Legacy_Uid__c='testemailarcheruser@gmail.com';
    insert c;
    
    IAM_Application__c iam=new IAM_Application__c();
    iam.IAM_Account_Name__c=[Select id,recordtype.Name,parentid From Account where Name =:'Identity Individual Users' limit 1].id;
    iam.IAM_Application_Name__c='Archer';
    iam.recordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Archer').getRecordTypeId();
    iam.IAM_Role__c='User';
    iam.IAM_Status__c='Active';
    insert iam;
    
     IAM_Contact_Provisioning__c conSolUserapp = new IAM_Contact_Provisioning__c () ;
        conSolUserapp.IAM_Account_Application__c = iam.id;
        conSolUserapp.IAM_Contact__c = c.id;
        conSolUserapp.IAM_Start_Date__c = System.today();
        conSolUserapp.IAM_End_Date__c = System.today()+365;
        conSolUserapp.IAM_Application_Name__c = 'Archer'  ;
        conSolUserapp.IAM_userId__c = 'testemailarcheruser@gmail.com';
        conSolUserapp.IAM_Status__c = 'pending';
        conSolUserapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Archer').getRecordTypeId(); 
        conSolUserapp.IAM_Role__c = 'User';
        System.debug('conSolUserapp... ' + conSolUserapp);
        insert conSolUserapp;   
        
        
      conSolUserapp.IAM_Status__c='Active';
      Update conSolUserapp;
       
    }
    
    
  
   
}