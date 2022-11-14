/** Class Name  : FSL_LightningFileUploadHandlerTest
*  Description  : Test class for FSL_LightningFileUploadHandler
*  Created By   : Madhavi P  
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
@IsTest
public class FSL_LightningFileUploadHandlerTest {
    
    @IsTest
    public static void LightningFileUploadHandlerTestMethod() {
        test.startTest();
        
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
        Asset  ast = new Asset();
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
        
        
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520-04892';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        insert serTer;
        
        Case  cs = new Case();
        cs.Status = 'Intake';
        //cs.Service_Territory__c = serTer.id;
        cs.AccountId = acc.id;
        cs.AssetId = ast.id;
        cs.Priority = 'Medium';
        insert cs; 
        
        
        
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Asset = ast;
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
        wo1.Case = cs;
        wo1.sub_status__c = 'Troubleshooting Complete';
        
        insert wo1;
        
        test.stoptest();    
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        
        insert cv;    
        List<Id> listdoc = new List<Id>();
        ContentDocument cd = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        listdoc.add(cd.Id);
        
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='SampleTitle', 
            PathOnClient ='SampleTitle.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = wo1.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        system.debug('111111111111  '+contentlink.ContentDocumentId);
        
        //create ContentDocumentLink record 
     /*   ContentDocumentLink cdl = New ContentDocumentLink(
            LinkedEntityId = acc.id,
            ContentDocumentId = cd.Id,
            ShareType = 'V'
        );
        
        try {
            insert cdl;
            // STUFF to PURPOSEFULLY 
            //System.assert(false, 'Exception expected');
        }catch(DmlException e) {
            System.assertEquals(e.getMessage(),'exception caused');
        } */
        
        Datetime dt = system.now()- (1/1440);
        string datevalue = string.valueOf(dt);
        FSL_LightningFileUploadHandler LFH = new FSL_LightningFileUploadHandler();
        FSL_LightningFileUploadHandler.getFiles(acc.Id,contentlink.ContentDocumentId, datevalue);
        FSL_LightningFileUploadHandler.deleteFile(cd.Id);
        FSL_LightningFileUploadHandler.deleteFiles(listdoc);
        
    }
}