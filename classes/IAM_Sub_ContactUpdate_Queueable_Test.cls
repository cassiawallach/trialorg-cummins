/************************************************************
Name:  IAM_Sub_ContactUpdate_Queueable_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is a queable class to update the Contact record Updates.                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram          01/16/2020        INITIAL DEVELOPMENT 
1.1 -    Karthik Raj Golakaram          01/03/2021      Made changes to make sure that we are calling LDAP API to remove changes
                                                        Also made changes to update Contact and User record.IAMOSMDEV                                                        
1.2 -    Shubhangi Sardar               09/06/2021      Corrected boolean variable
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_Sub_ContactUpdate_Queueable_Test{

static testmethod void test1()
 {    
     
      Account acc = new Account();
    acc.Name = 'TestAccount';
    acc.IAM_Service_Provider_Code__c = '123';
    acc.Type = 'Distributor Account';
    acc.CSS_DistributorCode__c = '1234';
    acc.CSS_DBCode__c = '12345';
    acc.CSS_DealerCode__c = '456';
    insert acc;
    
    List<Contact> lstcon = new list<contact>();
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.firstName = 'firstContact';
    con.Email = 'testContact@test.com';
    con.IAM_Contact_Status__c = 'Active';
    con.phone = '8989898989';
    con.IAM_Applications__c = 'abcd';
    con.IAM_Qsolexpiration__c = 'testABC';
    con.IAM_swregexpire__c ='testCon';
    con.IAM_Qsolview__c = 'testCon';
    con.IAM_Final_Approver__c = 'Y';
    Con.Username__c = 'test_user_helper@eidm.com';
    insert con;
    Set<Id> setIds = new Set<Id>();    
    setIds.add(con.id);
    Test.startTest();
    System.enqueueJob(new IAM_Sub_ContactUpdate_Queueable(setIds));
     ID jobID = System.enqueueJob(new IAM_Sub_UserUpdate_Queueable(setIds));
    Test.stopTest();
 } 

 static testmethod void test2()
 {    
     
      Account acc = new Account();
    acc.Name = 'TestAccount';
    acc.IAM_Service_Provider_Code__c = '123';
    acc.Type = 'Distributor Account';
    acc.CSS_DistributorCode__c = '1234';
    acc.CSS_DBCode__c = '12345';
    acc.CSS_DealerCode__c = '456';
    insert acc;
    
    List<Contact> lstcon = new list<contact>();
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.firstName = 'firstContact';
    con.Email = 'testContact@test.com';
    con.IAM_Contact_Status__c = 'Active';
    con.phone = '8989898989';
    con.IAM_Applications__c = 'abcd';
    con.IAM_Qsolexpiration__c = 'testABC';
    con.IAM_swregexpire__c ='testCon';
    con.IAM_Qsolview__c = 'testCon';
    con.IAM_Final_Approver__c = 'Y';
    Con.Username__c = 'test_user_helper@eidm.com';
    insert con;
    Set<Id> setIds = new Set<Id>();    
    setIds.add(con.id);
    Test.startTest();
    System.enqueueJob(new IAM_Sub_ContactUpdate_Queueable(setIds,false,false));
     ID jobID = System.enqueueJob(new IAM_Sub_UserUpdate_Queueable(setIds,false,false));
    Test.stopTest();
 } 


}