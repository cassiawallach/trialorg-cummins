//Changes for UAT Upload 2/22/2022
@isTest
public class FSL_FileUploadController_Test {
    
    private static String getRandomString() {
        String rs = String.valueOf(Math.random() * Datetime.now().getTime());
        return rs.substring(rs.length() - 15, rs.length() - 5);
    }
    
    
    static testMethod void fileTestMethod(){
        //    Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        //  Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        //    Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='9895634567';
        con.Email='av456@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST Mobile';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-02851';
        sT.FSL_Service_Territory_Code__c = '02851';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        sT.IsActive=true;
        insert sT;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        asst.Safety_Requirement__c=True;
        asst.Type__c='Engines';
        asst.Type_PSN__c='Engines-79644334';
        asst.Application_Code__c='234';
        asst.Individual__c = '';
        insert asst;
        
        
        
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        WorkOrder wo = new WorkOrder();
        wo.ServiceTerritoryId=sT.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=asst.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.SelectedSolution__c='abc';
        wo.FaultCodeId__c='1167';
        wo.Process_Step__c = 'Repair';
        wo.Category1__c = 'Leak';
        wo.Complaint_Type1__c='Air Leak';
        wo.Shop_Work_Order__c = 'test';
        wo.Mileage__c = null;
        wo.CSS_Hours__c = null;
        wo.Mileage_Measure__c = 'Miles';
        wo.Service_Model__c = 'New';
        wo.Status = 'Intake';
        WorkOrderList.add(wo);
        
        WorkOrder wo1 = new WorkOrder();
        wo1.ServiceTerritoryId=sT.id;
        wo1.AccountId=acc.id;
        wo1.ContactId=con.id;
        wo1.Repair_Location__c='In Shop';
        wo1.AssetId=asst.id;
        wo1.Available_for_Service__c=datetime.now()+3;
        wo1.SelectedSolution__c='abc';
        wo1.FaultCodeId__c='1167';
        wo1.Process_Step__c = 'Repair';
        wo1.Category1__c = 'Leak';
        wo1.Complaint_Type1__c='Air Leak';
        wo1.Shop_Work_Order__c = 'test';
        wo1.Mileage__c = 2232.21;
        wo1.CSS_Hours__c = 202;
        wo1.Mileage_Measure__c = 'MILES';
        wo1.Service_Model__c = 'New';
        wo1.Status = 'Repair';
        WorkOrderList.add(wo1);
        insert WorkOrderList;
        
        Case newCase = new Case();
        newCase.Subject = 'Unittest';
        newCase.Status = 'New';
        insert newCase;
        List<ID> idList =  new List<ID>();
        idList.add(newCase.Id);
        FSL_FileUploadController.getFilesList(idList);
        
        ContentVersion contentVersion = new ContentVersion(
            Title          = 'a picture',
            PathOnClient   = 'Pic.jpg',
            VersionData    = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = wo.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        List<ID> idCdList =  new List<ID>();
        idCdList.add(documents[0].Id);
        FSL_FileUploadController.updateWorkOrder(idCdList);
        FSL_FileUploadController.deleteSelectedFiles(idCdList);
        
        /*  Account acct = new Account(); 
acct.RecordTypeId = accGCRecId;
acct.Name = 'Test GC';
insert acct;
List<Asset> assList = new List<Asset>();
Asset asset = new Asset();
asset.Name = getRandomString();
asset.Type_PSN__c = getRandomString();
asset.Type__c = 'Engines';
asset.AccountId = acct.Id;
asset.Customer_Name__c = 'New Customer';
asset.Warranty_Start_Date__c = Date.today() - 100;
//  asset.FSL_Site__c = addressObj.Id;
Insert asset; 



WorkOrder wo21 = new WorkOrder();
wo21.Status = 'Intake';
wo21.ESN_Insite__c = getRandomString();
wo21.Process_Step__c = 'Repair';
wo21.Type__c = 'External';
wo21.AccountId = acct.id;
wo21.AssetId = asset.id;
wo21.Shop_Work_Order__c = getRandomString();
wo21.RecordTypeId = intakeRTID;
wo21.Repair_Location__c = 'Mobile';
Map<Id,Workorder> oldmap = new Map<Id,workorder>();
Map<Id,Workorder> newmap = new Map<Id,workorder>();
insert wo21;*/
        
    }
}