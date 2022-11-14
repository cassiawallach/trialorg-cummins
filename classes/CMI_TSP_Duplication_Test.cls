//Test class for TSP Duplication CMI_TSP_Duplication
@isTest
public with sharing class CMI_TSP_Duplication_Test {
    static testMethod void simpleTest(){
      Account a=new account();
      a.name='testTSP';
      a.CMI_Cummins_Support_Email__c='testTSP@gmail.com';
      Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Product_Connectivity').getRecordTypeId();
      a.RecordTypeId=RecordTypeId;
      insert a;
    
    
    
     //test start
     List<CMI_TSP__c>  mycm=new List<CMI_TSP__c> ();
     CMI_TSP__c cm=new CMI_TSP__c();
     cm.CMI_Account_Name__c=a.id;
     cm.CMI_TSP_Name__c='omnitracs';
     mycm.add(cm);
     
     //for other TSP
     CMI_TSP__c cmo=new CMI_TSP__c();
     cmo.CMI_Account_Name__c=a.id;
     cmo.CMI_TSP_Name__c='Other TSP';
     cmo.CMI_Other_TSP_Name__c='name of other TSP';
     mycm.add(cmo);
     insert mycm;
     
     //for update 
     cm.CMI_TSP_Name__c='DriverTech';
     //cm.CMI_TSP_Id__c='12312';
     cmo.CMI_Other_TSP_Name__c='name of other TSP';
     update cm;
     update cmo;
     //for delete
     delete mycm;
     
     //testing over
     }
  }