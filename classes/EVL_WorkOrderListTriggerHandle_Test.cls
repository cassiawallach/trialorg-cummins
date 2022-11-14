/**********************************************************************
Name:EVL_WorkOrderListTriggerHandle_Test 
Copyright © 2020  Cummins
======================================================
======================================================
Purpose: Test Classes for EVL_WorkOrderListTriggerHandle
======================================================
======================================================
History                                                            
VERSION     AUTHOR                      DATE                DETAIL                                 
1.0         Krishnamoorthi N            07/13/2020          INITIAL DEVELOPMENT 
2.0         Krishnamoorthi N            09/23/2020          Test Class for Update Service reports based on Creation user's Profile.
***********************************************************************/
//adding comment to deploy
@isTest
public with sharing class EVL_WorkOrderListTriggerHandle_Test {
    

    static testMethod void changeOwnerInfo() {
        list<Account> AL = new list<Account>();
        
        Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='02850';
        a.IAM_Service_Provider_Code__c='99945';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        AL.add(a);
        
        Account b=new Account();
        b.name='name';
        b.CSS_DistributorCode__c='05340';
        b.IAM_Service_Provider_Code__c='99946';
        b.Type='Dealer Account';
        b.Region__c = 'US and Canada';
        b.CMI_Account_Status__c = 'Active';
        AL.add(b);
        insert AL;
               
        Test.startTest();
        
        list<WorkOrder> wList = new list<WorkOrder>();
        WorkOrder w = new WorkOrder();
        w.AccountId = a.Id;
        insert w;
        
        wList.add(w);
        
        map<Id, WorkOrder> wMap = new map<Id, WorkOrder>();
        wMap.put(w.Id, w);
        
        EVL_WorkOrderListTriggerHandle.changeOwner(wList, null, true);
        EVL_WorkOrderListTriggerHandle.changeOwner(wList, wMap, false);
        
        w.AccountId = b.Id;
        update w;
        
        Test.stopTest();
		
    }
    
    static testMethod void populateAuditTrialTest() {
        list<Account> AL = new list<Account>();
        
        Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='02850';
        a.IAM_Service_Provider_Code__c='99945';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        AL.add(a);
        
        Account b=new Account();
        b.name='name';
        b.CSS_DistributorCode__c='05340';
        b.IAM_Service_Provider_Code__c='99946';
        b.Type='Dealer Account';
        b.Region__c = 'US and Canada';
        b.CMI_Account_Status__c = 'Active';
        AL.add(b);
        insert AL;
               
        Test.startTest();
        
        list<WorkOrder> wList = new list<WorkOrder>();
        WorkOrder w = new WorkOrder();
        w.AccountId = a.Id;
        insert w;
        
        wList.add(w);
        
        map<Id, WorkOrder> wMap = new map<Id, WorkOrder>();
        wMap.put(w.Id, w);
        
        EVL_WorkOrderListTriggerHandle.changeOwner(wList, null, true);
        EVL_WorkOrderListTriggerHandle.changeOwner(wList, wMap, false);
        
        w.AccountId = b.Id;
        w.EditComplaint__c = 'Test Compliant';
        w.EditCause__c = 'Test Cause';
        w.Correction_Notes__c = 'Test Correction Notes';
        w.Coverage_Notes_User_Comments__c = 'Test Comments';
        update w;
        
        Test.stopTest();
		
    }
    
    static testMethod void updateServiceReports() {
        list<Account> AL = new list<Account>();
        
        Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='02850';
        a.IAM_Service_Provider_Code__c='99945';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        AL.add(a);
        
        Account b=new Account();
        b.name='name';
        b.CSS_DistributorCode__c='05340';
        b.IAM_Service_Provider_Code__c='99946';
        b.Type='Dealer Account';
        b.Region__c = 'US and Canada';
        b.CMI_Account_Status__c = 'Active';
        AL.add(b);
        insert AL;
        
        list<WorkOrder> wList = new list<WorkOrder>();
        WorkOrder w = new WorkOrder();
        w.AccountId = a.Id;
        insert w;
        wList.add(w);
        Test.startTest();

        //to increase cvrg of FSL_servicereportTrigger
        
                ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = w.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        
        ServiceReport sr = new ServiceReport();
       // sr.ContentVersionDocumentId = documents[0].Id ;
        sr.DocumentBody = Blob.valueOf('Test Content') ; 
        sr.DocumentContentType ='application/pdf';
        sr.DocumentName='Test';
        sr.ParentId = w.Id ; 
        insert sr ;
        delete sr;

        
        EVL_WorkOrderListTriggerHandle.updateServiceReports(wList, true);
        EVL_WorkOrderListTriggerHandle.updateServiceReports(wList, false);
        
        Test.stopTest();
		
    }
    
    static testMethod void validateProductMH_Test() {
        list<Account> AL = new list<Account>();
        
        Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='02850';
        a.IAM_Service_Provider_Code__c='99945';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        AL.add(a);
        
        Account b=new Account();
        b.name='name';
        b.CSS_DistributorCode__c='05340';
        b.IAM_Service_Provider_Code__c='99946';
        b.Type='Dealer Account';
        b.Region__c = 'US and Canada';
        b.CMI_Account_Status__c = 'Active';
        AL.add(b);
        insert AL;
        
        list<WorkOrder> wList = new list<WorkOrder>();
        WorkOrder w = new WorkOrder();
        w.AccountId = a.Id;
        insert w;
        wList.add(w);
        
        map<Id, WorkOrder> wMap = new map<Id, WorkOrder>();
        wMap.put(w.Id, w);
        
        CSS_Solutions__c sol_Test = new CSS_Solutions__c();
        sol_Test.FSL_Service_Job__c = w.Id;
        sol_Test.Name='T00000690';
        sol_Test.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol_Test.FSL_Solution_Position__c='1';
        sol_Test.Diagnostic_Notes__c='Test';
        sol_Test.Repair_Notes__c='Good';
        sol_Test.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol_Test.Repair_Response__c='Repair Successful.';
        //sol_Test.FaultCode__c=fcode.Id;
        sol_Test.userTimestamp__c=datetime.now();
        insert sol_Test;
               
        Test.startTest();       
        
        try{
            w.CSS_Hours__c = 10;
            EVL_WorkOrderListTriggerHandle.validateProductMH(wList, wMap);
        }
        Catch(Exception e){
            System.debug('-----'+e.getMessage());
        }
        
        Test.stopTest();
		
    }
}