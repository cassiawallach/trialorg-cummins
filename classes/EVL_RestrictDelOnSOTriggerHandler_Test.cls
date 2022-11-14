/**********************************************************************
Name: EVL_RestrictDelOnSOTriggerHandler_Test
Class Name: EVL_RestrictDelOnClSOContentTriggerHandle
======================================================
======================================================
Purpose: Built for CT1-93                                                           
Restriction Content document from delete if service order is closed
======================================================a
======================================================a
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Sai Pisupati      02/19/2021      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class EVL_RestrictDelOnSOTriggerHandler_Test {
    
    public testmethod static void ContentDocumentRestrictDeletion_Test() {
        
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_Close').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
        Asset ast = new Asset();
        ast.Account = acc;
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = 'Engines-79963830';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c    ='56'; 
        ast.Type__c = 'Engines';
        insert ast;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '12345-12345';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        WorkOrder wo    = new WorkOrder();
        Id woRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();

        wo.AccountId    = acc.Id;
        wo.Type__c = 'Dealer';
        wo.RecordTypeId = woRTID;
        wo.AssetId      = ast.Id;
        wo.ServiceTerritoryId = objServiceTerritory.Id;
        wo.Status       = 'Intake';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = '';      
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        
        insert wo;
        
        wo.EVL_Stage__c = 'Closed';
        update wo;
        
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.debug('documents are ++++' + documents);
        
        ContentDocumentLink col = new ContentDocumentLink();
        col.LinkedEntityId = wo.Id;
        col.ContentDocumentId = documents[0].Id;
        col.Visibility = 'AllUsers';
        col.ShareType = 'V';
        insert col;
        
        Test.startTest();
        EVL_RestrictDelOnSOContentTriggerHandler.restricContentOnClosedSOBeforeDelete(documents);
        delete documents;
        Test.stopTest();
    }
}