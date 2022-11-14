@isTest
public class IAM_Archer_User_Creation_Test {
    
    /* Function used to create sample record for this test Class*/
    @isTest
    Static void InitData(){
        Account accSampleRecord = new Account(name='CumminsAPITest7',Type = 'Dealer Account',
                                    CMI_Account_Status__c = 'Active',
                                    CMI_CDA_Status__c='New Customer Request',
                                    //ParentId = accSampleRecord4.id,
                                    //CMI_Region__c = 'East Asia',
                                    CMI_Cummins_Support_Email__c = 'abcxyz123@gmail.com'
                                    );
    
    insert accSampleRecord;
    Account a= [SELECT Id,Name FROM Account WHERE name ='CumminsAPITest7'];
    Contact c= new Contact();
    c.AccountId=a.id;
    c.FirstName='TestArcher';
    c.LastName='LastArcher';
    c.Email='oh611@cummins.com';
    c.Username__c='testemailarcheruser@gmail.com';
    c.RecordTypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    c.IAM_Contact_Status__c = 'Pending';
    c.IAM_Approved__c='N';           
    c.CMI_Contact_Type__c='Secondary';
    c.IAM_from_Registration__c=true;
    c.IAM_Agreement_Signed_By__c = c.FirstName + ' '+ c.LastName;
    c.IAM_Agreement_Signed_On__c = date.today();
    c.IAM_Ext_Legacy_Uid__c='testemailarcheruser@gmail.com';
    insert c;
    
          IAM_Application__c app=new IAM_Application__c();
            app.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Archer').getRecordTypeId(); 
            app.IAM_Application_Name__c='Archer';
            app.IAM_Role__c='User';
            app.IAM_Account_Name__c=a.Id;
            app.IAM_Status__c='Active';
            insert app;
        
     IAM_Contact_Provisioning__c conSolUserapp = new IAM_Contact_Provisioning__c () ;
        conSolUserapp.IAM_Account_Application__c = app.id;
        conSolUserapp.IAM_Contact__c = c.id;
        conSolUserapp.IAM_Start_Date__c = System.today();
        conSolUserapp.IAM_End_Date__c = System.today()+365;
        conSolUserapp.IAM_Application_Name__c = 'Archer'  ;
        conSolUserapp.IAM_userId__c = 'testemailarcheruser@gmail.com';
        conSolUserapp.IAM_Status__c = 'Pending';
        conSolUserapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Archer').getRecordTypeId(); 
        conSolUserapp.IAM_Role__c = 'User';
        System.debug('conSolUserapp... ' + conSolUserapp);
        insert conSolUserapp;   
        
        
       // Cummins API App provisioning record and contact provisioning record
        IAM_Application__c appCAP=new IAM_Application__c();
            appCAP.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins API Portal').getRecordTypeId(); 
            appCAP.IAM_Application_Name__c='Cummins API Portal';
            appCAP.IAM_Role__c='API Owner';
            appCAP.IAM_Account_Name__c=a.Id;
            appCAP.IAM_Status__c='Active';
            insert appCAP;
            
            IAM_Contact_Provisioning__c userApp=new IAM_Contact_Provisioning__c();
            userApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins API Portal').getRecordTypeId(); 
            userApp.IAM_Application_Name__c='Cummins API Portal';
            userApp.IAM_Role__c='API Owner';
            userApp.IAM_Contact__c = c.Id;
            userApp.IAM_Status__c ='Pending';
            userApp.IAM_Account_Application__c=appCAP.Id;
            insert userApp;
          
        Set<id> Conids= new Set<id>();
        Conids.add(c.id);
        Set<id> conProvIds=new Set<id>();
        conProvIds.add(conSolUserapp.id);
        conProvIds.add(userApp.id);
    
            IAM_Archer_User_Creation.createUser(Conids,conProvIds)  ;  
    }
}