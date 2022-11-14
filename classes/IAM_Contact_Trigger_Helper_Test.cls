/*************************************************************************************
Name:  IAM_Contact_Trigger_Helper_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This is test class for IAM_Contact_Trigger_Helper_Test class.
**************************************************************************************
History
--------------------------------------------------------------------------------------                                                         
VERSION         AUTHOR                DATE              DETAIL                                
1.0     Karthik Raj Golakaram      04/12/2019        INITIAL DEVELOPMENT 
1.1     Chetan Gaikwad             12/04/2020      Made changes for market place deployment
1.2     Nishant Verma              12/09/2020      Made Changes for High Radisu Deployment  
1.3     Subhangi Sardar            12/18/2020      Made changes for CST
1.4     Karthik Raj Golakaram      01/29/2021      Made changes for Market place defect      
1.5     Shubhangi Sardar           01/06/2021      Added DN Value Change
1.6     Shubhangi Sardar           07/14/2021      Changed method from afterUpdate to beforeUpdate
1.7     Sandeep Vuyyuru            09/06/2021      Changes related to Powerspec
1.8     Anupam Adhikari            10/26/2021      Changes for Global Dealer Portal
1.9		Chetan Gaikwad			   09/09/2022	   CDO update API changes
****************************************************************************************
****************************************************************************************/
@isTest
public class IAM_Contact_Trigger_Helper_Test{
    
    @TestSetup
    static void BuildData(){
        
        Account accP=new Account();
        accP.Name='AccountP';
        accP.Type='Distributor Account';
        accP.BillingStreet='1260 N MARR ROAD';
        accP.BillingCity='COLUMBUS';
        accP.BillingState='Indiana';
        accP.BillingCountry='United States';
        accP.BillingPostalCode='47201';
        
        insert accP;
        
        
        Account acc1=new Account(); 
        acc1.Name='Account1';
        acc1.Type='Dealer Account';
        acc1.ParentId=accP.Id;
        acc1.BillingStreet='1260 N MARR ROAD';
        acc1.BillingCity='COLUMBUS';
        acc1.BillingState='Indiana';
        acc1.BillingCountry='United States';
        acc1.BillingPostalCode='47201';
        
        insert acc1;
        
        Account acc2=new Account(); 
        acc2.Name='Account2';
        acc2.Type='Dealer Account';
        acc2.ParentId=accP.Id;
        acc2.BillingStreet='1260 N MARR ROAD';
        acc2.BillingCity='COLUMBUS';
        acc2.BillingState='Indiana';
        acc2.BillingCountry='United States';
        acc2.BillingPostalCode='47201';
        
        insert acc2;
        
        List<Contact> lst=new List<Contact>(); 
        Contact c=new Contact();
        c.FirstName = 'myfirst';
        c.LastName ='mylast';
        c.Email = 'myemail@abc.com';
        c.Username__c = 'myuserid@abc.com';
        c.AccountId = acc1.ID;
        c.IAM_from_Registration__c=true;
        c.IAM_Contact_Status__c = 'Active';
        c.CMI_Contact_Type__c = 'Secondary';
        c.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        Contact c2=new Contact();
        c2.FirstName = 'myfirst2';
        c2.LastName ='mylast2';
        c2.Email = 'myemail2@abc.com';
        c2.Username__c = 'myuserid2@abc.com';
        c2.AccountId = acc1.ID;
        c2.IAM_from_Registration__c=false;
        c2.IAM_Contact_Status__c = 'Pending';
        c2.CMI_Contact_Type__c = 'Secondary';
        c2.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        //insert c; 
        lst.add(c);
        lst.add(c2);
        
        Contact cc=new Contact();
        cc.FirstName = 'myfirstreclaim';
        cc.LastName ='mylastrecliam';
        cc.Email = 'myemailrecliam@dd.com';
        cc.Username__c = 'myuserid99@test.com';
        cc.AccountId = acc1.ID;
        cc.IAM_Contact_Status__c = 'Active';
        cc.CMI_Contact_Type__c = 'Secondary';
        cc.IAM_Contact_source__c = 'SwReg';
        cc.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        //@Anupam - for GDP changes
        Contact ccc=new Contact();
        ccc.FirstName = 'myfirstreclaim';
        ccc.LastName ='mylastrecliam';
        ccc.Email = 'myemailrecliam@ddd.com';
        ccc.Username__c = 'myuserid999@test.com';
        ccc.AccountId = accP.ID;
        ccc.IAM_Contact_Status__c = 'Active';
        ccc.CMI_Contact_Type__c = 'Primary';
        ccc.IAM_Contact_source__c = 'SwReg';
        ccc.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        lst.add(ccc);
        //@Anupam changes end

        //insert cc;
        lst.add(cc);
        insert lst;
        //IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(lst,true,false);
        //IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(lst,false,true);
        
        List<Contact> lstupdate=new List<Contact>();
        c.IAM_from_Registration__c=false;
        //c.AccountId = acc2.ID;
        
        cc.LastName = 'lnametet';
        //lstupdate.add(cc);  
        
        c2.IAM_Contact_Status__c = 'Active';
        lstupdate.add(c2);
        //update lst;
        
        cc.IAM_Contact_Status__c='Rejected';
        cc.Username__c='myuseridchanged@test.com';
        lstupdate.add(cc);
        update lstupdate;
        
        List<String> lstt= new List<String>();
        lstt.add('myuseridchanged@test.com');
        IAM_Contact_Trigger_Helper.changeUsernameOfRejectedContact(lstt); 
        
        //@Anupam - for GDP
        
        IAM_Application__c accFeature=new IAM_Application__c();
        accFeature.IAM_Application_Name__c='Global Dealer Portal';
        accFeature.IAM_Role__c='Non-Dealer User';
        accFeature.IAM_Account_Name__c=accP.Id;
        accFeature.IAM_Status__c='Active';
        accFeature.recordtypeid= Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Global Dealer Portal').getRecordTypeId();
        
        insert accFeature;
        
    }
    
    @isTest
    public static void testall(){
        Test.startTest();
        try {
        List<Account> accList = [Select id,Type,Location__c from Account where name in('AccountP','Account1','Account2')];
        Set<Id> accountIds = new Set<Id>();
        for(Account acc:accList){
           accountIds.add(acc.Id); 
        }
        
        List<Contact> oldconList = [Select id,Account.Name,AccountId,Email,IAM_Contact_Status__c,IAM_from_Registration__c,IAM_From_API__c,IAM_Legacy_User__c,Recordtypeid,IAM_Contact_source__c,Username__c,IAM_Person_Type__c,IAM_Internal__c,IAM_swregexpire__c,FirstName,LastName,IAM_Product_Group_Access__c,IAM_NpbuDiagExpire__c,IAM_PasswordChangedTime__c,IAM_Reject_Reason__c,IAM_Reason__c,IAM_Work_Group_ID__c,CMI_Contact_Type__c,IAM_Contact_Owner__c from Contact where username__c in('myuserid@abc.com','myuserid2@abc.com','myuserid99@test.com','myuserid999@test.com')];
        
        Map<id,Contact> trigOldMap = new Map<id,Contact>();
        for(Contact con:oldconList){
            trigOldMap.put(con.id, con);
        }
        List<Contact> newconList = new List<Contact>();
        Contact oldContact1 = [Select id,Account.Name,AccountId,Email,IAM_Contact_Status__c,IAM_from_Registration__c,IAM_From_API__c,IAM_Legacy_User__c,Recordtypeid,IAM_Contact_source__c,Username__c,IAM_Person_Type__c,IAM_Internal__c,IAM_swregexpire__c,FirstName,LastName,IAM_Product_Group_Access__c,IAM_NpbuDiagExpire__c,IAM_PasswordChangedTime__c,IAM_Reject_Reason__c,IAM_Reason__c,IAM_Work_Group_ID__c,CMI_Contact_Type__c,IAM_Contact_Owner__c from Contact
        where username__c = 'myuserid@abc.com'];
        
        //Contact c=oldconList[0];
        Contact c=oldContact1;
        c.IAM_Contact_Status__c='Inactive';
        c.CMI_Contact_Type__c ='Secondary';
        
        Contact oldContact2 = [Select id,Account.Name,AccountId,Email,IAM_Contact_Status__c,IAM_from_Registration__c,IAM_From_API__c,IAM_Legacy_User__c,Recordtypeid,IAM_Contact_source__c,Username__c,IAM_Person_Type__c,IAM_Internal__c,IAM_swregexpire__c,FirstName,LastName,IAM_Product_Group_Access__c,IAM_NpbuDiagExpire__c,IAM_PasswordChangedTime__c,IAM_Reject_Reason__c,IAM_Reason__c,IAM_Work_Group_ID__c,CMI_Contact_Type__c,IAM_Contact_Owner__c from Contact
        where username__c = 'myuserid2@abc.com'];
        
        //Contact c1=oldconList[1];
        Contact c1 = oldContact2;
        Account acc = [SELECT Id FROM Account WHERE Name = 'Account2'];
        system.debug('#### old acc - '+c1.AccountId + ' #### Contact Id - '+c1.Id);
        system.debug('#### old acc 1 - '+acc.Id);
        //c1.AccountId=accList[0].id;
        c1.AccountId = acc.Id;
        
        newconList.add(c);
        newconList.add(c1);
        
        update newconList;
        List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE Id =: newconList[0].Id
        OR Id =: newconList[1].Id];
        for(Contact cmp : conList) {
            System.debug('#### new List Con - '+cmp.AccountId);
        }
        
        Map<id,Contact> trigNewMap = new Map<id,Contact>();
        for(Contact con:newconList){
            trigNewMap.put(con.id, con);
        }

        //@Anupam - For GDP
        Map<String,Contact> contactMap = new Map<String,Contact>();
        Map<String, IAM_Application__c> mapAppFeatureRecords = new Map<String, IAM_Application__c>();
        List<IAM_Application__c> accFeatureList = [Select id,IAM_Application_Name__c,IAM_Role__c,IAM_Account_Name__r.Id,
                                                   IAM_Status__c,IAM_Cumpas_Modularity__c from IAM_Application__c where IAM_Application_Name__c =:'Global Dealer Portal'];
         
        for(Contact conRec : oldconList){
                    for(IAM_Application__c acctFeatureRec : accFeatureList){
                        if(conRec.AccountId == acctFeatureRec.IAM_Account_Name__r.Id){
                            if(!mapAppFeatureRecords.containsKey(conRec.Id)){
                                mapAppFeatureRecords.put(conRec.Id, acctFeatureRec);
                                contactMap.put(conRec.Id, conRec);
                            } 
                        }
                    }
                    
                }
        IAM_Contact_Trigger_Helper.checkAccChangeFlag(accountIds);
        IAM_Contact_Trigger_Helper.unCheckAccChangeFlag(accountIds);
        IAM_Contact_Trigger_Helper.updateoldAccount(accountIds);
        
        IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(oldconList,true,false);
        IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(oldconList,false,true);
        
        IAM_Contact_Trigger_Helper.onAfterUpdate(newconList,oldconList,trigNewMap,trigOldMap);
        
        } catch(Exception e) {
            System.debug('#### - '+ e.getMessage());
        }
        Test.stopTest();
    }  

    @isTest
    public static void testall1(){
        Test.startTest();
        try {
        List<Account> accList = [Select id,Type,Location__c from Account where name in('AccountP','Account1','Account2')];
        Set<Id> accountIds = new Set<Id>();
        for(Account acc:accList){
           accountIds.add(acc.Id); 
        }
        
        List<Contact> oldconList = [Select id,Account.Name,AccountId,Email,IAM_Contact_Status__c,IAM_from_Registration__c,IAM_From_API__c,IAM_Legacy_User__c,Recordtypeid,IAM_Contact_source__c,Username__c,IAM_Person_Type__c,IAM_Internal__c,IAM_swregexpire__c,FirstName,LastName,IAM_Product_Group_Access__c,IAM_NpbuDiagExpire__c,IAM_PasswordChangedTime__c,IAM_Reject_Reason__c,IAM_Reason__c,IAM_Work_Group_ID__c,CMI_Contact_Type__c,IAM_Contact_Owner__c from Contact where username__c in('myuserid@abc.com','myuserid2@abc.com','myuserid99@test.com','myuserid999@test.com')];
        
        Map<id,Contact> trigOldMap = new Map<id,Contact>();
        for(Contact con:oldconList){
            trigOldMap.put(con.id, con);
        }
        List<Contact> newconList = new List<Contact>();
        Contact oldContact1 = [Select id,Account.Name,AccountId,Email,IAM_Contact_Status__c,IAM_from_Registration__c,IAM_From_API__c,IAM_Legacy_User__c,Recordtypeid,IAM_Contact_source__c,Username__c,IAM_Person_Type__c,IAM_Internal__c,IAM_swregexpire__c,FirstName,LastName,IAM_Product_Group_Access__c,IAM_NpbuDiagExpire__c,IAM_PasswordChangedTime__c,IAM_Reject_Reason__c,IAM_Reason__c,IAM_Work_Group_ID__c,CMI_Contact_Type__c,IAM_Contact_Owner__c from Contact
        where username__c = 'myuserid@abc.com'];
        
        //Contact c=oldconList[0];
        Contact c=oldContact1;
        c.IAM_Contact_Status__c='Inactive';
        
        Contact oldContact2 = [Select id,Account.Name,AccountId,Email,IAM_Contact_Status__c,IAM_from_Registration__c,IAM_From_API__c,IAM_Legacy_User__c,Recordtypeid,IAM_Contact_source__c,Username__c,IAM_Person_Type__c,IAM_Internal__c,IAM_swregexpire__c,FirstName,LastName,IAM_Product_Group_Access__c,IAM_NpbuDiagExpire__c,IAM_PasswordChangedTime__c,IAM_Reject_Reason__c,IAM_Reason__c,IAM_Work_Group_ID__c,CMI_Contact_Type__c,IAM_Contact_Owner__c from Contact
        where username__c = 'myuserid2@abc.com'];
        
        //Contact c1=oldconList[1];
        Contact c1 = oldContact2;
        Account acc = [SELECT Id FROM Account WHERE Name = 'Account2'];
        system.debug('#### old acc - '+c1.AccountId + ' #### Contact Id - '+c1.Id);
        system.debug('#### old acc 1 - '+acc.Id);
        //c1.AccountId=accList[0].id;
        c1.AccountId = acc.Id;
        
        newconList.add(c);
        newconList.add(c1);
        
        update newconList;
        List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE Id =: newconList[0].Id
        OR Id =: newconList[1].Id];
        for(Contact cmp : conList) {
            System.debug('#### new List Con - '+cmp.AccountId);
        }
        
        Map<id,Contact> trigNewMap = new Map<id,Contact>();
        for(Contact con:newconList){
            trigNewMap.put(con.id, con);
        }

        //@Anupam - For GDP
        Map<String,Contact> contactMap = new Map<String,Contact>();
        Map<String, IAM_Application__c> mapAppFeatureRecords = new Map<String, IAM_Application__c>();
        List<IAM_Application__c> accFeatureList = [Select id,IAM_Application_Name__c,IAM_Role__c,IAM_Account_Name__r.Id,
                                                   IAM_Status__c,IAM_Cumpas_Modularity__c from IAM_Application__c where IAM_Application_Name__c =:'Global Dealer Portal'];
         
        for(Contact conRec : oldconList){
                    for(IAM_Application__c acctFeatureRec : accFeatureList){
                        if(conRec.AccountId == acctFeatureRec.IAM_Account_Name__r.Id){
                            if(!mapAppFeatureRecords.containsKey(conRec.Id)){
                                mapAppFeatureRecords.put(conRec.Id, acctFeatureRec);
                                contactMap.put(conRec.Id, conRec);
                            } 
                        }
                    }
                    
                }
        
        IAM_Contact_Trigger_Helper.onBeforeUpdate(newconList,oldconList,trigNewMap,trigOldMap);
        
        //IAM_Contact_Trigger_Helper.contactAccessValidationForDistributor(newconList,true);
        //@Anupam changes for GDP
        IAM_Contact_Trigger_Helper.createUserFeature(newconList,true);
        IAM_Contact_Trigger_Helper.createUserFeatureAccessRecord(mapAppFeatureRecords,contactMap);
        
        } catch(Exception e) {
            System.debug('#### - '+ e.getMessage());
        }
        Test.stopTest();
    }  
}